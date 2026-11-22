class Tomlplusplus < Formula
  desc "Header-only TOML config file parser and serializer for C++17"
  homepage "https://marzer.github.io/tomlplusplus/"
  url "https://github.com/marzer/tomlplusplus/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "4821c769370a6489b6a37814f16f3769eee0f2e733a5c129d5d99e2515a95c2b"
  license "MIT"
  compatibility_version 2
  head "https://github.com/marzer/tomlplusplus.git", branch: "master"

  bottle do
    manifest_sha256 "00cda1a2259e0f5560ea76abdd1eb4293fdd5a7e43ceb74f89b489563473db33"
    sha256 cellar: :any_skip_relocation, all: "9f5ccc0fba3d61f0e6b5035e1eab6acf609296369ee4dbd2fac7d8f6795494f8"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <toml++/toml.hpp>

      int main()
      {
        std::string tomlContent = R"toml(
          # This is a TOML document

          title = "TOML Example"

          [owner]
          name = "Tom Preston-Werner"
          dob = 1979-05-27T07:32:00-08:00
        )toml";

        auto data = toml::parse(tomlContent);
        std::cout << "Title: " << data["title"].value_or("No title") << std::endl;
        return 0;
      }
    CPP

    pkg_config_flags = shell_output("pkgconf --cflags --libs tomlplusplus").chomp.split
    system ENV.cxx, "test.cpp", *pkg_config_flags, "-std=c++17", "-o", "test"
    assert_match "Title: TOML Example", shell_output("./test")
  end
end
