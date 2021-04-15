from geninfo import *

import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output, State
import pandas as pd
import plotly.express as px
import plotly.graph_objs as go

INITIAL_DATE = '21-02-01'
CHOOSED_COLUMN = "casos_fa_14acum_percapita"

app = dash.Dash(__name__)

df = pd.read_csv('data.csv')
df[CHOOSED_COLUMN]=df[CHOOSED_COLUMN]*100000

df['DATE']=df['DATE'].apply(lambda l : l[2:-15])
df=df[df['DATE']>=INITIAL_DATE]

gdf = gen_info()[2]

print('Generating graph...')
fig = px.choropleth(df,
                    animation_frame='DATE',
                    animation_group='LOCATION',
                    geojson=gdf.set_index('LOCATION'),
                    color_continuous_scale=px.colors.sequential.YlOrRd,
                    locations='LOCATION',
                    color=CHOOSED_COLUMN,
                    fitbounds="locations",
                    range_color = [0, max(df[CHOOSED_COLUMN])],
                    height=700,
                    )
print('Graph generated')

app.layout = html.Div(children=[
    html.H1(children= html.A('Santa Fe mapainteractivo', href='https://github.com/mariano22/easyseir')),
    html.H2(id='fecha_placeholder'),
    html.Div([dcc.Graph(figure=fig, id='map')])
])

if __name__ == '__main__':
    app.run_server(debug=True)
