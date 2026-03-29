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

  # docopt.cpp is not in homebrew-core; vendor it here
  resource "docopt.cpp" do
    url "https://github.com/docopt/docopt.cpp/archive/refs/tags/v0.6.3.tar.gz"
    sha256 "28af5a0c482c6d508d22b14d588a3b0bd9ff97135f99c2814a5aa3cbff1d6632"
  end

  # Mustache header-only library required by zimcheck
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
      extra_cxx = ""
      if OS.mac?
        sdk_cxx_include = MacOS::CLT.sdk_path/"usr/include/c++/v1"
        extra_cxx = "-isystem#{sdk_cxx_include}" if sdk_cxx_include.exist?
      end
      system "cmake", "-S", ".", "-B", "build",
                      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                      "-DCMAKE_CXX_FLAGS=#{extra_cxx}",
                      *std_cmake_args(install_prefix: docopt_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      # Remove shared libraries so -ldocopt links statically
      (docopt_prefix/"lib").glob("libdocopt*.dylib").each(&:unlink)
      (docopt_prefix/"lib").glob("libdocopt*.so*").each(&:unlink)
    end

    ENV.append_path "PKG_CONFIG_PATH", docopt_prefix/"lib/pkgconfig"

    extra_cxx_args = ["-I#{docopt_prefix}/include", "-I#{buildpath}/mustache"]
    if OS.mac?
      sdk_cxx_include = MacOS::CLT.sdk_path/"usr/include/c++/v1"
      extra_cxx_args << "-isystem#{sdk_cxx_include}" if sdk_cxx_include.exist?
    end

    # zimwriterfs uses UnicodeString from libicuuc but meson.build only declares icu-i18n
    icu4c = Formula["icu4c@78"]
    ENV.append "LDFLAGS", "-L#{icu4c.opt_lib} -licuuc"

    system "meson", "setup", "build",
                    "-Dcpp_args=#{extra_cxx_args.join(" ")}",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "zimcheck", shell_output("#{bin}/zimcheck --help", 255)
    assert_match "zimdump", shell_output("#{bin}/zimdump --help")
  end
end
