class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.14.0",
      revision: "1fd711bc8c20326dd8e9538e2c7e4cb1ebd67bdb"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "603f9db571c5a11951f2d2f7a07e4a1108c07798cd1f347dbf4736e6baf6d7b3"
    sha256 cellar: :any,                 arm64_sequoia: "e6cb0a6729f091b1d219c0ba4bfb995dfd3e2e2a445091550743ed273e1c5812"
    sha256 cellar: :any,                 arm64_sonoma:  "a536b93c09c30d3c6ba2970a4b5dbb00dc0b1b87d9edc006b1d639129ecf113c"
    sha256 cellar: :any,                 sonoma:        "e4173177423d3cc154d5a13b740793bd9045ad5c410e224e91766d35a8fa1b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c01b046eb63ab22c7567f7ecfe3f48dabdb17f410658184e11eecf32ddb5ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7e36a54cfde07f9cf24edfdc3ff570621414264cd20f4d4b9a83c2e9b8dab3"
  end

  depends_on "cxxopts" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "asio"
  depends_on "openssl@3"

  # Apply changes from open PR to fix build with newer Asio
  # PR ref: https://github.com/VROOM-Project/vroom/pull/1279
  patch :DATA

  # remove jthread usage, upstream PR ref, https://github.com/VROOM-Project/vroom/pull/1065
  patch do
    url "https://github.com/VROOM-Project/vroom/commit/0cd72771fb79840a2a0ff64a58f0c18830665119.patch?full_index=1"
    sha256 "b271c6a7f27c17fbc5eb47c7b80bd697e29af8f631a4e27d68d00f9b08e9e9f9"
  end

  def install
    # Use brewed dependencies instead of vendored dependencies
    cd "include" do
      rm_r(["cxxopts", "rapidjson"])
      mkdir_p "cxxopts"
      ln_s Formula["cxxopts"].opt_include, "cxxopts/include"
      ln_s Formula["rapidjson"].opt_include, "rapidjson"
    end

    files = %w[
      src/routing/http_wrapper.h
      src/utils/input_parser.cpp
      src/utils/output_json.cpp
      src/utils/output_json.h
    ]
    inreplace files, "../include/rapidjson/include/rapidjson", "rapidjson"

    cd "src" do
      system "make"
    end
    bin.install "bin/vroom"
    pkgshare.install "docs"
  end

  test do
    output = shell_output("#{bin}/vroom -i #{pkgshare}/docs/example_2.json")
    expected_routes = JSON.parse((pkgshare/"docs/example_2_sol.json").read)["routes"]
    actual_routes = JSON.parse(output)["routes"]
    assert_equal expected_routes, actual_routes
  end
end

__END__
diff --git a/src/routing/http_wrapper.cpp b/src/routing/http_wrapper.cpp
index 474de70e..80d0131d 100644
--- a/src/routing/http_wrapper.cpp
+++ b/src/routing/http_wrapper.cpp
@@ -37,14 +37,12 @@ std::string HttpWrapper::send_then_receive(const std::string& query) const {
   std::string response;
 
   try {
-    asio::io_service io_service;
+    asio::io_context io_context;
 
-    tcp::resolver r(io_service);
+    tcp::resolver r(io_context);
 
-    tcp::resolver::query q(_server.host, _server.port);
-
-    tcp::socket s(io_service);
-    asio::connect(s, r.resolve(q));
+    tcp::socket s(io_context);
+    asio::connect(s, r.resolve(_server.host, _server.port));
 
     asio::write(s, asio::buffer(query));
 
@@ -86,16 +84,14 @@ std::string HttpWrapper::ssl_send_then_receive(const std::string& query) const {
   std::string response;
 
   try {
-    asio::io_service io_service;
+    asio::io_context io_context;
 
     asio::ssl::context ctx(asio::ssl::context::method::sslv23_client);
-    asio::ssl::stream<asio::ip::tcp::socket> ssock(io_service, ctx);
-
-    tcp::resolver r(io_service);
+    asio::ssl::stream<asio::ip::tcp::socket> ssock(io_context, ctx);
 
-    tcp::resolver::query q(_server.host, _server.port);
+    tcp::resolver r(io_context);
 
-    asio::connect(ssock.lowest_layer(), r.resolve(q));
+    asio::connect(ssock.lowest_layer(), r.resolve(_server.host, _server.port));
     ssock.handshake(asio::ssl::stream_base::handshake_type::client);
 
     asio::write(ssock, asio::buffer(query));
