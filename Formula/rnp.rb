class Rnp < Formula
  desc "OpenPGP tools for encrypting, decrypting, signing, and verifying files"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp.git", :tag => "v0.13.1"
  head "https://github.com/rnpgp/rnp.git"

  depends_on "cmake" => :build
  depends_on "botan"
  depends_on "json-c"

  def install
    botan = Formula["botan"]
    jsonc = Formula["json-c"]

    tag = `git describe`
    ohai "Building tag #{tag}"
    # only required to set when can't be determined automatically
    # version tag

    mkdir "build" do
      system(
        "cmake",
        "-DBUILD_SHARED_LIBS=ON",
        "-DBUILD_TESTING=OFF",
        "-DCMAKE_INSTALL_PREFIX=#{prefix}",
        "-DCMAKE_PREFIX_PATH=#{botan.prefix};#{jsonc.prefix}",
        *std_cmake_args,
        "..",
      )
      system "make", "install"
    end
  end

  test do
    system "rnp", "--version"
  end
end
