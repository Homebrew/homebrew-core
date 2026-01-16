class Tomlplusplus < Formula
  desc "Header-only TOML config file parser and serializer for C++17"
  homepage "https://marzer.github.io/tomlplusplus/"
  url "https://github.com/marzer/tomlplusplus/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "8517f65938a4faae9ccf8ebb36631a38c1cadfb5efa85d9a72e15b9e97d25155"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "871dfe4e410d713db5ee049a54446fc0d421163a1fc30a66d3d9c1946c886640"
    sha256 cellar: :any,                 arm64_sequoia:  "3934d4a98565c6b3161550033341f13c4e74085b3de259e57f09007c5a03b940"
    sha256 cellar: :any,                 arm64_sonoma:   "40067a1ffc31cf6fdcb26161a1809b815a8d82a63afdf93232dd81521329e05d"
    sha256 cellar: :any,                 arm64_ventura:  "871c57fbe77aa04bba1388ac0ca4e0ccf4c125333a84b84a860a6548a2bffb8f"
    sha256 cellar: :any,                 arm64_monterey: "71e6c4e3940782e94ba05fb8357430b56c973b1ff867340ce966acfdc649f6c4"
    sha256 cellar: :any,                 sonoma:         "6771afc5d63e1df3d2fd8858c305ef28e97df6cd43808692431f6a84881665c9"
    sha256 cellar: :any,                 ventura:        "a7496d680b31e37abfbb26e8117132a1b9833058d3bda72335ace6dcffcf6277"
    sha256 cellar: :any,                 monterey:       "1f3418dd05029a34c9cf2a64d798c35f7553094aae8c9c702f82b736317d6dc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aee73aaa4f42f852a53342e4575e66309e76197eb2fefcaf0385a298562d0e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f59dade0a31cf96a7708117ae8b8cb743bfacab47972dcdeb30ee1a8ba84bd5f"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

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
