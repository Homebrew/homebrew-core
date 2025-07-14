class Rsyncy < Formula
  desc "Status/progress bar for rsync"
  homepage "https://github.com/laktak/rsyncy"
  url "https://github.com/laktak/rsyncy/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d2b88602cd911d66a21750bec32a40fdfb3769a63b529bc0805d22c7a3b87ba2"
  license "MIT"
  head "https://github.com/laktak/rsyncy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d497726367711d8d1a895ead4a6fa888e797a523c027cbc4f4934173803c8c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d497726367711d8d1a895ead4a6fa888e797a523c027cbc4f4934173803c8c7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d497726367711d8d1a895ead4a6fa888e797a523c027cbc4f4934173803c8c7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f55977e00c3f3332fff7a5c1e1496772a029495d444f864e0d2eb4f9e21119ff"
    sha256 cellar: :any_skip_relocation, ventura:       "f55977e00c3f3332fff7a5c1e1496772a029495d444f864e0d2eb4f9e21119ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b7ff0ec6c2c7e4564370e7ede4c760136fae508f3a9312b9ebacb4f0a0f1ef3"
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
