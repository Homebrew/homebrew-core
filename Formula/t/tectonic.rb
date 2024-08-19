class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.15.0.tar.gz"
  sha256 "3c13de312c4fe39ff905ad17e64a15a3a59d33ab65dacb0a8b9482c57e6bc6aa"
  license "MIT"
  revision 1
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "85647768c6b32b1cceebac4c541e5efbb99fdc566924fe4559f6533d161eb06a"
    sha256 cellar: :any,                 arm64_ventura:  "39804b39b3a365a653c64bd7c38ed9f8f8375b7295b4b488d65a9a0ea45fe465"
    sha256 cellar: :any,                 arm64_monterey: "88d39d53987fbe343aecb1dba5b388bd87981bcef6f378ce16be169732f93d16"
    sha256 cellar: :any,                 sonoma:         "eecc9938bf7b89cdb57054f9f098ebc619a284fa6f6fe077f984ff8497c35a35"
    sha256 cellar: :any,                 ventura:        "aa1b9a3cca1c889ac3140030b3b940d18de821a75e7b10211cf20940add18c04"
    sha256 cellar: :any,                 monterey:       "29b6de4cf2fa8ea3de5f209fe3cfd3608cca115954989eb674679d1dd9651b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d15114dca090265bdd487b79a65295ff695ee1c928c5471fd1ad633fccfebc0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl@3"

  def install
    ENV.cxx11

    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s # needed for CLT-only builds
      ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra
    end

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", "--features", "external-harfbuzz", *std_cargo_args
    bin.install_symlink bin/"tectonic" => "nextonic"
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")

    system bin/"nextonic", "new", "."
    system bin/"nextonic", "build"
    assert_predicate testpath/"build/default/default.pdf", :exist?, "Failed to create default.pdf"
  end
end
