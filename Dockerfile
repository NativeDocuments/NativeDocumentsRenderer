# To build it manually:
# sudo docker build -t nativedocumentswebapp .
# sudo docker run -d -P  --volumes-from nddata --link ndstore:ndstore --name ndwebapp nativedocuments/nativedocumentswebapp
# sudo docker run -d -p 9020:9015 --volumes-from nddata --link ndstore:ndstore --name ndwebapp nativedocuments/nativedocumentswebapp
# sudo docker run -d -p 9015:9015 -v ~/nds.license:/opt/NativeDocumentsWebApp/nds.license --link ndstore:ndstore --name ndwebapp nativedocuments/nativedocumentswebapp

FROM busybox:musl
ADD http://downloads.nativedocuments.com/NativeDocumentsWebApp.tar.gz /tmp/
RUN mkdir /opt
RUN tar xzf /tmp/NativeDocumentsWebApp.tar.gz -C /opt
RUN rm -f /tmp/NativeDocumentsWebApp.tar.gz
# OPTIONAL: add hyphenation dictionaries
ADD http://downloads.nativedocuments.com/dict/hyph_en_US.dic /opt/NativeDocumentsWebApp/
ADD http://downloads.nativedocuments.com/dict/hyph_de_DE.dic /opt/NativeDocumentsWebApp/
#RUN mkdir -p /opt/NativeDocumentsWebApp/log
#RUN mkdir -p /opt/NativeDocumentsWebApp/documents
RUN mkdir -p /opt/NativeDocumentsWebApp/tmp
ENV NDS_LOG_FILE=/dev/stdout
#ENV NDS_LOG_DIR=/opt/NativeDocumentsWebApp/log
#ENV NDS_CONVERTER_DOCUMENTS_DIR=/opt/NativeDocumentsWebApp/documents
ENV NDS_LOG_DIR=/nddata/log/NativeDocumentsWebApp
ENV NDS_CONVERTER_DOCUMENTS_DIR=/nddata/storage
ENV NDS_BASE_DIR=/opt/NativeDocumentsWebApp/tmp
ENV NDS_MAX_CONNECTIONS=500
ENV NOOX_SERVICE_ENABLE_SYNC=1
ENV NOOX_SERVICE_ENABLE_SYNC_ADDR=\$NDSTORE_PORT_6000_TCP_ADDR
ENV NOOX_SERVICE_ENABLE_SYNC_PORT=\$NDSTORE_PORT_6000_TCP_PORT
ENV NOOX_SERVICE_TERMINATE_ON_LOAD=1
ENV NDS_LICENSE=/opt/NativeDocumentsWebApp/nds.license
ENV NDS_VERBOSE=2
ENTRYPOINT ["/opt/NativeDocumentsWebApp/ndwebappd", "service=0.0.0.0:9015"]
EXPOSE 9015
