FROM python:3.11

RUN pip install cellxgene-gateway==0.3.11 werkzeug==2.3
RUN perl -0777 -i -pe 's{(crawler\slink\sabove</li>)(.*?<\/ol>)}{$1\n\t\t<li><a href="\/logout">logout<\/a><\/li>$2}gms' /usr/local/lib/python3.11/site-packages/cellxgene_gateway/templates/index.html

ENV CELLXGENE_DATA=/cellxgene-data
ENV CELLXGENE_LOCATION=/usr/local/bin/cellxgene

CMD ["cellxgene-gateway"]
