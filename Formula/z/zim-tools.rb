class ZimTools < Formula
  desc "ZIM command-line tools: zimcheck, zimdump, zimsplit, zimwriterfs and more"
  homepage "https://github.com/openzim/zim-tools"
  url "https://github.com/openzim/zim-tools/archive/refs/tags/3.6.0.tar.gz"
  sha256 "5e740767d503858af58eab9c687c1c80b9a45882ef25f5d617103c50e9c1dde0"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "gumbo-parser"
  depends_on "icu4c@78"
  depends_on "libmagic"
  depends_on "libzim"

  uses_from_macos "zlib"

  # TODO: separate as a new formula once upstream releases a new tag
  resource "docopt.cpp" do
    url "https://github.com/docopt/docopt.cpp/archive/refs/tags/v0.6.3.tar.gz"
    sha256 "28af5a0c482c6d508d22b14d588a3b0bd9ff97135f99c2814a5aa3cbff1d6632"
  end

  # TODO: separate as a new formula once upstream releases a new tag
  resource "mustache" do
    url "https://github.com/kainjow/Mustache/archive/refs/tags/v4.1.tar.gz"
    sha256 "acd66359feb4318b421f9574cfc5a511133a77d916d0b13c7caa3783c0bfe167"
  end

  def install
    # Install Mustache header into buildpath so meson's has_header check finds it
    resource("mustache").stage do
      (buildpath/"mustache").install "mustache.hpp"
    end

    # Build and stage docopt.cpp into a local prefix so meson can find it via pkg-config
    docopt_prefix = buildpath/"docopt_prefix"
    resource("docopt.cpp").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                      *std_cmake_args(install_prefix: docopt_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      # Remove shared libraries so -ldocopt links statically
      (docopt_prefix/"lib").glob("libdocopt*.dylib").each(&:unlink)
      (docopt_prefix/"lib").glob("libdocopt*.so*").each(&:unlink)
    end

    ENV.append_path "PKG_CONFIG_PATH", docopt_prefix/"lib/pkgconfig"
    ENV.append_to_cflags "-I#{docopt_prefix}/include"
    ENV.append_to_cflags "-I#{buildpath}/mustache"

    icu4c = Formula["icu4c@78"]
    ENV.append "LDFLAGS", "-L#{icu4c.opt_lib} -licuuc"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Create a minimal HTML directory and illustration for further tests
    (testpath/"html/index.html").write "<html><head><title>Test</title></head><body>Hello</body></html>"

    # 48x48 grey PNG illustration required by zimwriterfs (base64-encoded)
    require "base64"
    (testpath/"html/icon.png").binwrite(Base64.decode64(<<~PNG.gsub(/\s+/, "")))
      iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAARklEQVR4nO3OIQEAIBAAse+f
      jFj4N5Mgbgk25zPzOrAVkkJSSApJISkkhaSQFJJCUkgKSSEpJIWkkBSSQlJICkkhKSSF5AIp
      URk8hH3rGwAAAABJRU5ErkJggg==
    PNG

    # zimwriterfs: create a ZIM file from the HTML directory (with FT index for zimsearch)
    system bin/"zimwriterfs",
      "--welcome=index.html", "--illustration=icon.png",
      "--language=eng", "--name=test", "--title=Test ZIM",
      "--description=Test", "--creator=Test", "--publisher=Test",
      testpath/"html", testpath/"test.zim"
    assert_path_exists testpath/"test.zim"

    # zimcheck: verify the created ZIM passes integrity checks
    assert_match "Overall Test Status: Pass", shell_output("#{bin}/zimcheck #{testpath}/test.zim")

    # zimdump info: check metadata fields
    dump_info = shell_output("#{bin}/zimdump info #{testpath}/test.zim")
    assert_match "count-entries", dump_info
    assert_match "main page: index.html", dump_info

    # zimdump list: verify expected entries are present
    assert_match "index.html", shell_output("#{bin}/zimdump list #{testpath}/test.zim")

    # zimdump show: retrieve article content
    assert_match "Hello", shell_output("#{bin}/zimdump show --url=index.html #{testpath}/test.zim")

    # zimrecreate: recreate the ZIM and verify it is still valid
    system bin/"zimrecreate", testpath/"test.zim", testpath/"recreated.zim"
    assert_match "Overall Test Status: Pass", shell_output("#{bin}/zimcheck #{testpath}/recreated.zim")

    # zimsplit: split into parts and confirm at least one part is created
    system bin/"zimsplit", "--prefix=#{testpath}/part", testpath/"test.zim"
    assert_path_exists Dir["#{testpath}/part*"].first

    # zimdiff: compute diff between the original and recreated ZIM
    system bin/"zimdiff", testpath/"test.zim", testpath/"recreated.zim", testpath/"test.diff"
    assert_path_exists testpath/"test.diff"

    # zimsearch: search for content within the FT-indexed ZIM
    assert_match "Test", shell_output("#{bin}/zimsearch #{testpath}/test.zim Hello")

    # zimbench: benchmark ZIM file reading on the test ZIM
    assert_match "urls collected", shell_output("#{bin}/zimbench #{testpath}/test.zim 2>&1")
  end
end
