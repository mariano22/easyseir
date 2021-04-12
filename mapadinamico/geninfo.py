import geopandas as gpd
import pandas as pd
import urllib.request, json
import geopandas as gpd
import unicodedata

def normalize_str(s):
    """ Function for name normalization (handle áéíóú) """
    if type(s)==float:
        assert math.isnan(s)
        return ''
    return unicodedata.normalize("NFKD", s).encode("ascii","ignore").decode("ascii").upper().lstrip().rstrip()

def gen_info():
    """ Generate the DataFrames with meta info (covidstats id, population and geografical) """
    # Carga la metainfo de departamentos de covidstas y filtramos departamentos de Santa Fe
    covidstats_meta_df = pd.read_csv('covidstats.csv',sep=';')
    covidstats_meta_df['LOCATION']='ARGENTINA/'+covidstats_meta_df['Provincia'].apply(normalize_str)+'/'+covidstats_meta_df['Departamento'].apply(normalize_str)
    covidstats_meta_df=covidstats_meta_df[covidstats_meta_df['LOCATION'].apply(lambda l : l.startswith('ARGENTINA/SANTA FE'))]
    covidstats_meta_df

    # Cargamos la info poblacional y chequemos que tengamos toda la info
    info_df=pd.read_csv('info_general.csv')
    s = set(info_df['LOCATION'])
    for l in set(covidstats_meta_df['LOCATION']):
        if l not in s:
            print('FALTA INFO DE: {}'.format(l))

    # Cargamos la info geografica y chequemos que tengamos toda la info
    gdf = gpd.read_file('maps_general.geojson')
    gdf=gdf[gdf['LOCATION'].apply(lambda l : l.startswith('ARGENTINA/SANTA FE'))]
    s = set(gdf['LOCATION'])
    for l in set(covidstats_meta_df['LOCATION']):
        if l not in s:
            print('FALTA INFO GEOGRAFICA DE: {}'.format(l))
    return covidstats_meta_df, info_df, gdf

def get_data(department_id):
    """ Dado un id de departamento de covidstats obtiene los datos """
    url='https://covidstats.com.ar/ws/evolucion?comprimido=1&departamentos[]={}'
    with urllib.request.urlopen(url.format(department_id)) as req:
        return json.loads(req.read().decode())

COLUMNS = ['dias_confirmacion_fallecimiento', 'terapia', 'casos_con_fis', 'casos_dx', 'fallecidos_reporte', 'dias_diagnostico_terapia', 'dias_diagnostico_fallecimiento', 'casos_fis_ajustada', 'diagnosticos', 'casos_fa', 'casos_reporte', 'internados', 'sospechosos_fa', 'fallecidos_fa', 'casos_reporte_sin_pcr', 'dias_confirmacion_diagnostico', 'casos_fis', 'fallecidos', 'dias_apertura_diagnostico', 'dias_fis_diagnostico']
COLUMNS_PEOPLE = ['terapia', 'casos_con_fis', 'casos_dx', 'fallecidos_reporte', 'casos_fis_ajustada', 'diagnosticos', 'casos_fa', 'casos_reporte', 'internados', 'sospechosos_fa', 'fallecidos_fa', 'casos_reporte_sin_pcr', 'casos_fis', 'fallecidos']

def covidstats_df(data):
    """ Dado un json de datos de un deparamento de covidstats devuelve un DataFrame con:
        - indice la fecha
        - casos_fa, casos_reporte
        - CAMPO_acum el acumulado respectivo
        - CAMPO_14acum acumulado en 14 dias
    """
    day = pd.Series(pd.date_range(data['fecha_inicial'], freq="D", periods=len(data['casos_fa'])))
    df=pd.DataFrame(index=day, columns=COLUMNS,data=zip(*[data[c] for c in COLUMNS]))
    df=df.sort_index()
    for c in COLUMNS:
        df[c+'_acum']=df[c].cumsum()
        df[c+'_14acum']=df[c+'_acum'].diff(14)
    return df

def covidstats_dfs(covidstats_meta_df):
    """ Dado un dataframe con LOCATIO, ID departamento CovidStats construye las series respectivas de toda region """
    dfs=[]
    for _,r in covidstats_meta_df.iterrows():
        location=r['LOCATION']
        print('Procesando {}'.format(location))
        data = get_data(r['ID departamento CovidStats'])
        assert data['fecha_inicial']=='2020-01-01T00:00:00-03:00'
        df = covidstats_df(data)
        df['LOCATION']=location
        dfs.append(df)
    return pd.concat(dfs).reset_index().rename(columns={'index':'DATE'})

def gen_data():
    covidstats_meta_df, info_df, gdf = gen_info()
    df = covidstats_dfs(covidstats_meta_df)
    df = pd.merge(df,info_df,on='LOCATION',how='left')
    for c in COLUMNS_PEOPLE:
        for pref in ['', '_acum', '_14acum']:
            col = c+pref
            df[col+'_percapita'] = df[col]/df['POPULATION']
    df.to_csv('data.csv', index=False)
    return df

def df_toplot(df, date):
    df_result = df[df['DATE']==date]
    df_result.set_index('LOCATION')
    return df_result

if __name__ == "__main__":
    # Chequeo que todas las fechas iniciales sean las mismas
    # assert len(set(get_data(r['ID departamento CovidStats'])['fecha_inicial'] for _,r in covidstats_meta_df.iterrows()))==1
    gen_data()
