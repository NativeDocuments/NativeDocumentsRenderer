# To build it manually:
# sudo docker build -t nativedocumentsrenderer .
# sudo docker run -d -P -v nddata:/nddata --link ndstore:ndstore --name ndrenderer nativedocuments/nativedocumentsrenderer
# sudo docker run -d -p 9015:9015 -v ~/nds.license:/opt/NativeDocumentsRenderer/nds.license --link ndstore:ndstore --name ndrenderer nativedocuments/nativedocumentsrenderer

FROM busybox:musl
VOLUME ["/nddata"]
ADD http://downloads.nativedocuments.com/NativeDocumentsRenderer.tar.gz /tmp/
RUN mkdir /opt
RUN tar xzf /tmp/NativeDocumentsRenderer.tar.gz -C /opt
RUN rm -f /tmp/NativeDocumentsRenderer.tar.gz
# OPTIONAL: add hyphenation dictionaries
ADD http://downloads.nativedocuments.com/dict/hyph_en_US.dic /opt/NativeDocumentsRenderer/
ADD http://downloads.nativedocuments.com/dict/hyph_de_DE.dic /opt/NativeDocumentsRenderer/
#RUN mkdir -p /opt/NativeDocumentsRenderer/log
#RUN mkdir -p /opt/NativeDocumentsRenderer/documents
RUN mkdir -p /opt/NativeDocumentsRenderer/tmp
ENV NDS_LOG_FILE=/dev/stdout
#ENV NDS_LOG_DIR=/opt/NativeDocumentsRenderer/log
#ENV NDS_CONVERTER_DOCUMENTS_DIR=/opt/NativeDocumentsRenderer/documents
ENV NDS_LOG_DIR=/nddata/log/NativeDocumentsRenderer
ENV NDS_CONVERTER_DOCUMENTS_DIR=/nddata/storage
ENV NDS_BASE_DIR=/opt/NativeDocumentsRenderer/tmp
ENV NDS_MAX_CONNECTIONS=500
ENV NOOX_SERVICE_ENABLE_SYNC=1
#ENV NOOX_SERVICE_ENABLE_SYNC_ADDR=\$NDSTORE_PORT_6000_TCP_ADDR
#ENV NOOX_SERVICE_ENABLE_SYNC_PORT=\$NDSTORE_PORT_6000_TCP_PORT
ENV NOOX_SERVICE_ENABLE_SYNC_ADDR=ndstore
ENV NOOX_SERVICE_ENABLE_SYNC_PORT=6000
ENV NOOX_SERVICE_TERMINATE_ON_LOAD=1
ENV NDS_LICENSE=/opt/NativeDocumentsRenderer/nds.license
ENV NDS_VERBOSE=0
ENTRYPOINT ["/bin/sh", "-c", "mkdir -p /nddata/storage; mkdir -p /nddata/log/NativeDocumentsRenderer; exec /opt/NativeDocumentsRenderer/ndrenderd service=0.0.0.0:9015"]
EXPOSE 9015
