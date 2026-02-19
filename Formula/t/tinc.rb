class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.36.tar.gz"
  mirror "http://tinc-vpn.org/packages/tinc-1.0.36.tar.gz"
  sha256 "40f73bb3facc480effe0e771442a706ff0488edea7a5f2505d4ccb2aa8163108"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.tinc-vpn.org/download/"
    regex(/href=.*?tinc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "fec5d5550d6c34b8ed4a77e0df8a9eb507057df30076f9806e1dab5f10cf797a"
    sha256 cellar: :any,                 arm64_sequoia: "557684567c679c553dd157dbe92f4740160e2f2a0521d4910e3e40d7578c613d"
    sha256 cellar: :any,                 arm64_sonoma:  "d17dfcc53d3d26a6168cfb5a1630653308b853801f7495568a9f341d59c5ddc3"
    sha256 cellar: :any,                 sonoma:        "f40c710167e11b42b729de6be12b8dbda24caa4b238739d4e3176a8ac7e00eb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "badc117b77ec0ad57a0954ac307698fa34223beb9406a210a30c6f64b0d5e08e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6929dbbd4bc0cbc6e790bedd9be5a92493e1b3810bc7b93c421200eac3c046ef"
  end

  depends_on "lzo"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # fix build errors, upstream pr ref, https://github.com/gsliepen/tinc/pull/464
  patch :DATA

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"

    (var/"run/tinc").mkpath
  end

  service do
    run [opt_sbin/"tincd", "--config=#{etc}/tinc", "--pidfile=#{var}/run/tinc/tinc.pid", "-D"]
    keep_alive true
    require_root true
    working_dir etc/"tinc"
    log_path var/"log/tinc/stdout.log"
    error_log_path var/"log/tinc/stderr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
end

__END__
diff --git a/src/net_socket.c b/src/net_socket.c
index 6195c16..e072970 100644
--- a/src/net_socket.c
+++ b/src/net_socket.c
@@ -102,14 +102,14 @@ static bool bind_to_interface(int sd) {

 #if defined(SOL_SOCKET) && defined(SO_BINDTODEVICE)
 	memset(&ifr, 0, sizeof(ifr));
-	strncpy(ifr.ifr_ifrn.ifrn_name, iface, IFNAMSIZ);
-	ifr.ifr_ifrn.ifrn_name[IFNAMSIZ - 1] = 0;
+	strncpy(ifr.ifr_name, iface, IFNAMSIZ);
+	ifr.ifr_name[IFNAMSIZ - 1] = 0;
 	free(iface);

 	status = setsockopt(sd, SOL_SOCKET, SO_BINDTODEVICE, (void *)&ifr, sizeof(ifr));

 	if(status) {
-		logger(LOG_ERR, "Can't bind to interface %s: %s", ifr.ifr_ifrn.ifrn_name, strerror(errno));
+		logger(LOG_ERR, "Can't bind to interface %s: %s", ifr.ifr_name, strerror(errno));
 		return false;
 	}

@@ -157,13 +157,13 @@ int setup_listen_socket(const sockaddr_t *sa) {
 		struct ifreq ifr;

 		memset(&ifr, 0, sizeof(ifr));
-		strncpy(ifr.ifr_ifrn.ifrn_name, iface, IFNAMSIZ);
-		ifr.ifr_ifrn.ifrn_name[IFNAMSIZ - 1] = 0;
+		strncpy(ifr.ifr_name, iface, IFNAMSIZ);
+		ifr.ifr_name[IFNAMSIZ - 1] = 0;
 		free(iface);

 		if(setsockopt(nfd, SOL_SOCKET, SO_BINDTODEVICE, (void *)&ifr, sizeof(ifr))) {
 			closesocket(nfd);
-			logger(LOG_ERR, "Can't bind to interface %s: %s", ifr.ifr_ifrn.ifrn_name, strerror(sockerrno));
+			logger(LOG_ERR, "Can't bind to interface %s: %s", ifr.ifr_name, strerror(sockerrno));
 			return -1;
 		}

diff --git a/src/raw_socket_device.c b/src/raw_socket_device.c
index f4ed694..cf13fe9 100644
--- a/src/raw_socket_device.c
+++ b/src/raw_socket_device.c
@@ -61,12 +61,12 @@ static bool setup_device(void) {
 #endif

 	memset(&ifr, 0, sizeof(ifr));
-	strncpy(ifr.ifr_ifrn.ifrn_name, iface, IFNAMSIZ);
-	ifr.ifr_ifrn.ifrn_name[IFNAMSIZ - 1] = 0;
+	strncpy(ifr.ifr_name, iface, IFNAMSIZ);
+	ifr.ifr_name[IFNAMSIZ - 1] = 0;

 	if(ioctl(device_fd, SIOCGIFINDEX, &ifr)) {
 		close(device_fd);
-		logger(LOG_ERR, "Can't find interface %s: %s", ifr.ifr_ifrn.ifrn_name, strerror(errno));
+		logger(LOG_ERR, "Can't find interface %s: %s", ifr.ifr_name, strerror(errno));
 		return false;
 	}

@@ -76,7 +76,7 @@ static bool setup_device(void) {
 	sa.sll_ifindex = ifr.ifr_ifindex;

 	if(bind(device_fd, (struct sockaddr *) &sa, (socklen_t) sizeof(sa))) {
-		logger(LOG_ERR, "Could not bind %s to %s: %s", device, ifr.ifr_ifrn.ifrn_name, strerror(errno));
+		logger(LOG_ERR, "Could not bind %s to %s: %s", device, ifr.ifr_name, strerror(errno));
 		return false;
 	}
