#EXTRACTION

import pandas as pd
import requests
from io import StringIO
def Extracted_data():
    url='https://drive.google.com/file/d/1SzmRIwlpL5PrFuaUe_1TAcMV0HYHMD_b/view'
    file_id = url.split('/')[-2]
    dwn_url='https://drive.google.com/uc?export=download&id=' + file_id
    url2 = requests.get(dwn_url).text
    csv_raw = StringIO(url2)
    covid_19_df = pd.read_csv(csv_raw)
    covid_19_df.columns = covid_19_df.columns.str.lower()
    return covid_19_df
Extracted_data()



#LOADING TO POSTGRESQL DATABASE 
from sqlalchemy import create_engine
engine = create_engine('postgresql://postgres:{My_password}@localhost:5432/capstone_project')
engine.connect()
covid_19_df.to_sql('covid_19_data',con=engine,if_exists='append')


