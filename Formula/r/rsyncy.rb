class Rsyncy < Formula
  desc "Status/progress bar for rsync"
  homepage "https://github.com/laktak/rsyncy"
  url "https://github.com/laktak/rsyncy/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "72c1053309e8e478f1f1c13b35043d91099551d551bf7fcbef5c35ca32ec1481"
  license "MIT"
  head "https://github.com/laktak/rsyncy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d8b127e5b3edd289cb7946ae036f00bd7b4d55c01288ce62bb5e3d2ed0bd810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d8b127e5b3edd289cb7946ae036f00bd7b4d55c01288ce62bb5e3d2ed0bd810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d8b127e5b3edd289cb7946ae036f00bd7b4d55c01288ce62bb5e3d2ed0bd810"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d9d4d2d28545158b946ed85af0cb8aaeae397b8656c6dc50075e057fbccb6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f732892925d5b98a6cfa223c7c0a2c86c48529b6cd78919004a43dfe25e9914c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f340cdf67cf15d3a9f18ba1acf9b3194f71576bbfe7bcbc3d2da7950a9101e76"
  end

  depends_on "go" => :build
  depends_on "rsync"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # rsyncy is a wrapper, rsyncy --version will invoke it and show rsync output
    assert_match(/.*rsync.+version.*/, shell_output("#{bin}/rsyncy --version"))

    # test copy operation
    mkdir testpath/"a" do
      mkdir "foo"
      (testpath/"a/foo/one.txt").write <<~EOS
        testing
        testing
        testing
      EOS
      system bin/"rsyncy", "-r", testpath/"a/foo/", testpath/"a/bar/"
      assert_path_exists testpath/"a/bar/one.txt"
    end
  end
end
