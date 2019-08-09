MAKEF=$(MAKE) -f Makefile.in
TMPDIR=tmp

default: all

all: test ping loop tcp udp nc httpd

clean:
	$(MAKEF) clean SRCDIRS=". base utils event http http/client http/server examples $(TMPDIR)"

prepare:
	-mkdir -p $(TMPDIR)

test: prepare
	-rm $(TMPDIR)/*.o $(TMPDIR)/*.h $(TMPDIR)/*.c $(TMPDIR)/*.cpp
	cp main.cpp.tmpl $(TMPDIR)/main.cpp
	$(MAKEF) TARGET=$@ SRCDIRS=". base utils $(TMPDIR)"

ping:
	-rm base/hsocket.o
	$(MAKEF) TARGET=$@ SRCDIRS="" SRCS="examples/ping.c base/hsocket.c base/htime.c base/RAII.cpp" INCDIRS=". base" DEFINES="PRINT_DEBUG"

loop: prepare
	-rm $(TMPDIR)/*.o $(TMPDIR)/*.h $(TMPDIR)/*.c $(TMPDIR)/*.cpp
	cp examples/loop.c $(TMPDIR)
	$(MAKEF) TARGET=$@ SRCDIRS=". base event $(TMPDIR)"

tcp: prepare
	-rm $(TMPDIR)/*.o $(TMPDIR)/*.h $(TMPDIR)/*.c $(TMPDIR)/*.cpp
	cp examples/tcp.c $(TMPDIR)
	$(MAKEF) TARGET=$@ SRCDIRS=". base event $(TMPDIR)"

udp: prepare
	-rm $(TMPDIR)/*.o $(TMPDIR)/*.h $(TMPDIR)/*.c $(TMPDIR)/*.cpp
	cp examples/udp.c $(TMPDIR)
	$(MAKEF) TARGET=$@ SRCDIRS=". base event $(TMPDIR)"

nc: prepare
	-rm $(TMPDIR)/*.o $(TMPDIR)/*.h $(TMPDIR)/*.c $(TMPDIR)/*.cpp
	cp examples/nc.c $(TMPDIR)
	$(MAKEF) TARGET=$@ SRCDIRS=". base event $(TMPDIR)"

httpd: prepare
	-rm $(TMPDIR)/*.o $(TMPDIR)/*.h $(TMPDIR)/*.c $(TMPDIR)/*.cpp
	cp examples/httpd.cpp examples/httpd_conf.h examples/http_api_test.h $(TMPDIR)
	$(MAKEF) TARGET=$@ SRCDIRS=". base utils event http http/server $(TMPDIR)"

webbench:
	$(MAKEF) TARGET=$@ SRCDIRS="" SRCS="examples/webbench.c"

# curl
CURL_SRCDIRS := http http/client
CURL_INCDIRS += base utils http http/client
CURL_SRCS    += examples/curl.cpp base/hstring.cpp base/hbase.c
curl:
	$(MAKEF) TARGET=$@ SRCDIRS="$(CURL_SRCDIRS)" INCDIRS="$(CURL_INCDIRS)" SRCS="$(CURL_SRCS)" DEFINES="CURL_STATICLIB" LIBS="curl"

.PHONY: clean prepare test ping loop tcp udp nc httpd webbench curl
