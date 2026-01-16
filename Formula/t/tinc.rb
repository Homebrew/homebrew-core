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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9387ad8982b1f4471517f5edee95e4f6aa272a47ebfa86adbad67c7c019d3a85"
    sha256 cellar: :any,                 arm64_sequoia: "aa59254216d5b699c9656872ddf6cd268d0ca8370e340116e56ec192c4c26f40"
    sha256 cellar: :any,                 arm64_sonoma:  "bdcb1f7311ec710a0b372b7c28793f6ab29a4be5346775c0f4751f54e1913053"
    sha256 cellar: :any,                 sonoma:        "645b7d301ba9e5d979deb444801639e5933e2b8ad67d1db0cca420dadc0fdf07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efec5d1ef53cede8a0d1acf38ac128c7be0f13d47eee5bde73e9c2c4f6c2736f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00197b538b9a810f768fb915e71bf1bd0bdf8f5ef24c2abcacb053259d1681ba"
  end

  depends_on "lzo"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
