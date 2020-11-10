import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.express as px
import pandas as pd
import world_bank_data as wb
import unicodedata
from collections import defaultdict
from dash.dependencies import Input, Output, State
from io import StringIO
from datetime import date
import requests


def load_global_data():
    countries = wb.get_countries()
    df = countries.loc[countries.region != 'Aggregates',['region','name']]
    df['population'] = wb.get_series('SP.POP.TOTL', id_or_value='id', simplify_index=True, mrv=1)
    return df.reset_index()



countries_df = load_global_data()
covidstats_df = pd.read_csv('covidstats.csv',sep=';')
province_id_to_name = { r['Id provincia INDEC']: r['Provincia'] for _,r in covidstats_df.iterrows() }
department_id_to_name = defaultdict(dict)
for _,r in covidstats_df.iterrows():
    department_id_to_name[r['Id provincia INDEC']][r['ID departamento CovidStats']] = r['Departamento']

PARAMETROS_EPIDEMOLOGICOS = [('TI',3), ('TD',11), ('TC',12), ('TM',18), ('TR',18)]

app = dash.Dash(__name__)


fn_dailyCases = 'scripts/dailyCases.csv'
df_dailyCases = pd.read_csv(fn_dailyCases, index_col=0, header=None).transpose().rename(columns={0: 'dailyCases'})

fig_dailyCases = px.line(df_dailyCases, y='dailyCases' , title='Casos diarios')
fig_dailyCases2 = px.line(df_dailyCases, y='dailyCases' , title='Casos diarios')

app.layout = html.Div(children=[
    html.H1(children= html.A('EasySEIR COVID-19', href='https://github.com/mariano22/easyseir')),

    html.Div(children='Prueba de concepto de la simulación de Ernesto Kofman'),

    html.H2('Datos'),
    html.Div([
    html.Label('Pais'),
    dcc.Dropdown(id='country',
                 options=[{'label': r['name'], 'value': r['id']} for _,r in countries_df.iterrows()],
                 value='ARG'),
    ],style={'width': '33%','display': 'inline-block'}),
    html.Div([
        html.Label('Provincia'),
        dcc.Dropdown(id='province', options=[]),
    ],style={'width': '33%','display': 'inline-block'}),
    html.Div([
        html.Label('Departamento'),
        dcc.Dropdown(id='department', options=[]),
    ],style={'width': '33%','display': 'inline-block'}),

    html.H2('Parametros epidemológicos:'),
    *[ html.Div([
                html.Label(label_name+'  '),
                dcc.Input(id=label_name, value=default_value, type='number'),
                ],style={'width': str(100.0/len(PARAMETROS_EPIDEMOLOGICOS))+'%','display': 'inline-block'})
            for label_name, default_value in PARAMETROS_EPIDEMOLOGICOS ],

    html.H2('Parametros sociales:'),
    html.Div([
        html.Button(id='submit-r-clear', n_clicks=0, children='Limpiar fechas',style={'width': '33%','display': 'inline-block'}),
        html.Button(id='submit-r-break', n_clicks=0, children='Agregar fecha',style={'width': '33%','display': 'inline-block'}),
        dcc.DatePickerSingle(
            id='r-break-calendar',
            initial_visible_month=date.today(),
            display_format='DD/MM/YYYY',
            date=date.today(),
            style={'width': '33%','display': 'inline-block'})
        ]),
    html.Label('R-breaks dates: '),
    html.P(id='r-breaks-dates',children=''),


    html.Button(id='submit-button', n_clicks=0, children='Submit'),
    html.P(id='placeholder'),

    html.H2('Gráficas'),
    html.Div([
        dcc.Graph(
            id='dailyCases',
            figure=fig_dailyCases
        ),
        dcc.Graph(
            id='dailyCases2',
            figure=fig_dailyCases2
        )
        ],style={'columnCount': 2})
])

@app.callback(
    Output(component_id='province', component_property='options'),
    [Input(component_id='country', component_property='value')]
)
def update_province_list(country):
    if country!='ARG':
        return []
    return [ {'label':v, 'value':k}  for k,v in province_id_to_name.items()]

@app.callback(
    Output(component_id='department', component_property='options'),
    [Input(component_id='province', component_property='value')]
)
def update_province_list(province_id):
    if not province_id:
        return []
    return [ {'label':v, 'value':k}  for k,v in department_id_to_name[province_id].items()]

@app.callback(
    Output('placeholder','children'),
    [Input(component_id='submit-button', component_property='n_clicks')],
    [State('province', 'value'), State('department', 'value') ] + [ State(l,'value') for l,_ in PARAMETROS_EPIDEMOLOGICOS ]
)
def generate_json(n_clicks, province_id, department_id, *args):
    if n_clicks>0:
        url = 'https://covidstats.com.ar/ws/evolucion'
        default_params = {'sexo':'','comprimido':1, 'edaddesde':'', 'edadhasta':''}
        provs_ids = [province_id]
        provincia_params = {'provincias[]': id for id in provs_ids}
        deps_ids = [department_id]
        deps_params = {'departamentos[]': id for id in deps_ids}
        r = requests.get(url = url, params={**default_params, **provincia_params, **deps_params})
        x = r.json()
        print(args)
        x.update( zip(list(zip(*PARAMETROS_EPIDEMOLOGICOS))[0],args) )
        print(list(x))
    return ''

@app.callback(
    Output('r-breaks-dates','children'),
    [Input(component_id='submit-r-break', component_property='n_clicks'),
     Input(component_id='submit-r-clear', component_property='n_clicks')],
    [State('r-break-calendar','date'), State('r-breaks-dates', 'children')]
)
def agregar_r_break(n_clicks_add, n_clicks_clear, new_date, dates):
    ctx = dash.callback_context
    triggered = [ p['prop_id'] for p in ctx.triggered ]
    print(triggered)
    if 'submit-r-break.n_clicks' in triggered:
        return dates+' '+str(new_date)
    return ''



if __name__ == '__main__':
    app.run_server(debug=True)
