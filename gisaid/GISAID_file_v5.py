import pandas as pd

#list of metadata files to be merged
metadata_list=['Run_469 Metadata_Trim.xlsx']
ids_list=['goodSeqs.txt']

final_metadata=pd.DataFrame()

for metadata_file in metadata_list:
    df=pd.read_excel(metadata_file)
    print(df)
    print(final_metadata)
    if final_metadata.empty:
        final_metadata=df

    else:
        final_metadata=pd.concat([final_metadata,df])

print(final_metadata)

final_ids_df=pd.DataFrame()
for ids_file in ids_list:
    ids_df = pd.read_csv(ids_file, sep="\t",names=["LIMS ID"])
    if final_ids_df.empty:
        final_ids_df=ids_df

    else:
        final_ids_df=pd.concat([final_ids_df,ids_df])

final_ids_df=final_ids_df.sort_values(by=['LIMS ID'])
print(final_ids_df)

final_df=pd.merge(final_metadata,final_ids_df,how='right')
print(final_df)

final_df['date'] = pd.to_datetime(final_df['Collection Date'])
final_df['Year']=pd.DatetimeIndex(final_df['date']).year
print(final_df['date'])
print(final_df['Year'])

#df.to_excel('target_metadata_run141_goodseqs.xlsx')


#df.to_excel('target_metadata_run136_goodseqs.xlsx')


#Read in GISAID template file

xls = pd.ExcelFile('20220613_EpiCoV_BulkUpload_Template.xls')
#df1 = pd.read_excel(xls, 'Instructions', header=[0,1])
GISAID_template = pd.read_excel(xls, 'Submissions', header=[0,1])
#GISAID_template=pd.read_excel('20210222_EpiCoV_BulkUpload_Template.xls', header=[0,1])
print(GISAID_template)


def seq_name(a,b,c):
    print(a)
    print(b)
    print(c)
    if a=='South Africa':
        final_name="hCoV-19/"+"SouthAfrica"+"/CERI-KRISP-"+b+"/"+str(int(c))
    else:
        final_name="hCoV-19/"+a+"/CERI-KRISP-"+b+"/"+str(int(c))
    return final_name


def location_merge(a,b):
    print("San")
    print(a)
    print(b)
    final_location="Africa / "+a+" / "+b
    return final_location

def author_list(a):
    final_authors=str(a)+", Maponga T, Wilson S, Claassen M, Stander T, van Zyl G, Preiser W, Giandhari J, Pillay S, Naidoo Y, Sankon TJ, Maharaj A, Anyaneji UJ, Moir M, Van Wyk S, San JE, Tshiabuila D, Tegally H, Wilkinson E, de Oliveira T"
    return final_authors

GISAID_template[('covv_virus_name', 'Virus name')]=final_df.apply(lambda x: seq_name(x['Country'],x['LIMS ID'],x['Year']), axis=1)
GISAID_template[('covv_location', 'Location')]=final_df.apply(lambda x: location_merge(x['Country'],x['Province']), axis=1)
GISAID_template[('covv_authors', 'Authors')]=final_df.apply(lambda x: author_list(x['Authors']), axis=1)
GISAID_template[('covv_add_location', 'Additional location information')]=final_df['Patient District']
GISAID_template[('covv_collection_date', 'Collection date')]=final_df['Collection Date']
GISAID_template[('covv_gender', 'Gender')]=final_df['Patient Gender']
GISAID_template[('covv_patient_age', 'Patient age')]=final_df['Patient Age']
#GISAID_template[('covv_add_host_info', 'Additional host information')]=final_df['Additional information']
GISAID_template[('covv_orig_lab', 'Originating lab')]=final_df['Originating Laboratory']
GISAID_template[('covv_orig_lab_addr', 'Address')]=final_df['Address']

GISAID_template[('submitter', 'Submitter')].fillna(value='tuliodna', inplace=True)
GISAID_template[('covv_passage', 'Passage details/history')].fillna(value='Original', inplace=True)
GISAID_template[('covv_type', 'Type')].fillna(value='betacoronavirus', inplace=True)
GISAID_template[('covv_host', 'Host')].fillna(value='Human', inplace=True)
GISAID_template[('covv_patient_status', 'Patient status')].fillna(value='unknown', inplace=True)
GISAID_template[('covv_specimen', 'Specimen source')].fillna(value='Nasopharyngeal and oropharyngeal swab', inplace=True)
GISAID_template[('covv_seq_technology', 'Sequencing technology')].fillna(value='Illumina MiSeq', inplace=True)
GISAID_template[('covv_assembly_method', 'Assembly method')].fillna(value='Genome Detective v2.11.2', inplace=True)
GISAID_template[('covv_subm_lab_addr', 'Address')].fillna(value='Stellenbosch Medical School and Nelson R. Mandela School of Medicine, University of KwaZulu-Natal, 719 Umbilo Road, Durban, South Africa', inplace=True)
GISAID_template[('covv_subm_lab', 'Submitting lab')].fillna(value='CERI, Centre for Epidemic Response and Innovation, Stellenbosch University and KRISP, KZN Research Innovation and Sequencing Platform, UKZN.', inplace=True)


print(GISAID_template)
#Read in originating lab/author table

#Renaming file
rename_df=final_df['LIMS ID']+","+GISAID_template[('covv_virus_name', 'Virus name')]
print(rename_df)
rename_df.to_csv('rename.txt', sep=' ', index=False)


#### Making GISAID file

writer = pd.ExcelWriter('GISAID_submission_file_run469.xls')
#df1.to_excel(writer,'Instructions', header=False)
GISAID_template.to_excel(writer,'Submissions')

# data.fillna() or similar.

final_df.to_excel(writer,'metadata')
writer.save()
