class Scdl < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to download music from SoundCloud"
  homepage "https://github.com/scdl-org/scdl"
  url "https://files.pythonhosted.org/packages/29/68/602ea370bb383a043f577787a4bbfd9f4e193ffcbe1a7b6325e37f126a08/scdl-3.0.4.tar.gz"
  sha256 "afb72fb28293584d16fe96e399b686aab6bdfaa6f5303c5fd81e42feb76b09d5"
  license "GPL-2.0-only"
  head "https://github.com/scdl-org/scdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c53dd9bca484cb1314f2b245366cfe2827398fd37cb90825dfdf7c33b124834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50aade0c02039ee017426aaae3aaecd5a1317ab9a2ca43760893c30871369024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce7782e4ea3d28c9388ccfad4175ecc41fd38b94e9b05cdf21ac4e99d39075a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0119c66fbca86e2385c89eaa216a3b7f28e666c6651a060ca0290fff64cec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60ab05fbd09e5ab81f729edd62c934749e68a50726bf0fc0ef79dce5022c697a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440a651fb52aa6dbfea3b5e05f3127d22df5d75092933d31889233f64dc5ff39"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "ffmpeg"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cffi]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/9b/c9/0067d9a25ed4592b022d4558157fcdb6e123516083700786d38091688767/curl_cffi-0.14.0.tar.gz"
    sha256 "5ffbc82e59f05008ec08ea432f0e535418823cda44178ee518906a54f27a5f0f"

    # Backport of upstream fix for v0.14.0. upstream pr ref, https://github.com/lexiforest/curl_cffi/pull/697
    patch :DATA
  end

  resource "dacite" do
    url "https://files.pythonhosted.org/packages/55/a0/7ca79796e799a3e782045d29bf052b5cde7439a2bbb17f15ff44f7aacc63/dacite-1.9.2.tar.gz"
    sha256 "6ccc3b299727c7aa17582f0021f6ae14d5de47c7227932c47fec4cdfefd26f09"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soundcloud-v2" do
    url "https://files.pythonhosted.org/packages/a0/a3/5df894f113268c456d3e1ad94a8530ff5a39931a81449507f4627d67dcde/soundcloud_v2-1.6.1.tar.gz"
    sha256 "b6646e7883a9986a92bdfb6caded9ca65453899f90517e47ecf82d21ca0ae627"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/58/d9/55ffff25204733e94a507552ad984d5a8a8e4f9d1f0d91763e6b1a41c79b/yt_dlp-2026.2.21.tar.gz"
    sha256 "4407dfc1a71fec0dee5ef916a8d4b66057812939b509ae45451fa8fb4376b539"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scdl --version").chomp

    output = shell_output("#{bin}/scdl -l https://soundcloud.com/forss/city-ports 2>&1")
    assert_match "[download] Destination: #{testpath}/[290] Forss - City Ports.m4a", output
    assert_match "[download] 100%", output
  end
end

__END__
diff --git a/libs.json b/libs.json
index 5d63db1..03c334d 100644
--- a/libs.json
+++ b/libs.json
@@ -30,8 +30,10 @@
         "system": "Darwin",
         "machine": "x86_64",
         "pointer_size": 64,
-        "libdir": "/Users/runner/work/_temp/install/lib",
+        "libdir": "",
         "sysname": "macos",
+        "link_type": "static",
+        "obj_name": "libcurl-impersonate.a",
         "so_name": "libcurl-impersonate.4.dylib",
         "so_arch": "x86_64"
     },
@@ -39,8 +41,10 @@
         "system": "Darwin",
         "machine": "arm64",
         "pointer_size": 64,
-        "libdir": "/Users/runner/work/_temp/install/lib",
+        "libdir": "",
         "sysname": "macos",
+        "link_type": "static",
+        "obj_name": "libcurl-impersonate.a",
         "so_name": "libcurl-impersonate.4.dylib",
         "so_arch": "arm64"
     },
diff --git a/scripts/build.py b/scripts/build.py
index f40a6f0..ed17fdf 100644
--- a/scripts/build.py
+++ b/scripts/build.py
@@ -50,10 +50,12 @@ def detect_arch():
 
 arch = detect_arch()
 print(f"Using {arch['libdir']} to store libcurl-impersonate")
+obj_name = arch.get("obj_name", arch["so_name"])
+so_arch = arch.get("arch", arch["so_arch"])
 
 
 def download_libcurl():
-    if (Path(arch["libdir"]) / arch["so_name"]).exists():
+    if (Path(arch["libdir"]) / obj_name).exists():
         print(".so files already downloaded.")
         return
 
@@ -63,7 +65,7 @@ def download_libcurl():
     url = (
         f"https://github.com/lexiforest/curl-impersonate/releases/download/"
         f"v{__version__}/libcurl-impersonate-v{__version__}"
-        f".{arch['so_arch']}-{sysname}.tar.gz"
+        f".{so_arch}-{sysname}.tar.gz"
     )
 
     print(f"Downloading libcurl-impersonate from {url}...")
@@ -86,6 +88,10 @@ def download_libcurl():
 def get_curl_archives():
     print("Files for linking")
     print(os.listdir(arch["libdir"]))
+    if arch["system"] == "Darwin" and arch.get("link_type") == "static":
+        return [
+            f"{arch['libdir']}/{obj_name}",
+        ]
     if arch["system"] == "Linux" and arch.get("link_type") == "static":
         # note that the order of libraries matters
         # https://stackoverflow.com/a/36581865
@@ -130,9 +136,11 @@ def get_curl_libraries():
             "iphlpapi",
             "cares",
         ]
-    elif arch["system"] == "Darwin" or (
-        arch["system"] == "Linux" and arch.get("link_type") == "dynamic"
-    ):
+    elif arch["system"] == "Darwin":
+        if arch.get("link_type") == "dynamic":
+            return ["curl-impersonate"]
+        return []
+    elif arch["system"] == "Linux" and arch.get("link_type") == "dynamic":
         return ["curl-impersonate"]
     else:
         return []
@@ -142,6 +150,15 @@ ffibuilder = FFI()
 system = platform.system()
 root_dir = Path(__file__).parent.parent
 download_libcurl()
+extra_objects = get_curl_archives()
+if system == "Darwin" and arch.get("link_type") == "static":
+    extra_objects = []
+    extra_link_args = [
+        f"-Wl,-force_load,{arch['libdir']}/{obj_name}",
+        "-lc++",
+    ]
+else:
+    extra_link_args = ["-lstdc++"] if system != "Windows" else []
 
 
 ffibuilder.set_source(
@@ -151,7 +168,7 @@ ffibuilder.set_source(
     """,
     # FIXME from `curl-impersonate`
     libraries=get_curl_libraries(),
-    extra_objects=get_curl_archives(),
+    extra_objects=extra_objects,
     library_dirs=[arch["libdir"]],
     source_extension=".c",
     include_dirs=[
@@ -165,7 +182,7 @@ ffibuilder.set_source(
     extra_compile_args=(
         ["-Wno-implicit-function-declaration"] if system == "Darwin" else []
     ),
-    extra_link_args=(["-lstdc++"] if system != "Windows" else []),
+    extra_link_args=extra_link_args,
 )
 
 with open(root_dir / "ffi/cdef.c") as f:
