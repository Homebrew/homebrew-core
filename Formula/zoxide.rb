class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.0.tar.gz"
  sha256 "9a9b0aa82a647fa834e4ade483af292e50080758af25c5260c425420879d9691"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01eb64d2102e80ebad17d54160c3b92eecc909e6c29dc7d158f62bc9d9538f96"
    sha256 cellar: :any_skip_relocation, big_sur:       "3444b476a003119f6a08515b2846585c649a6b031932c1d18a04b7e346e92f32"
    sha256 cellar: :any_skip_relocation, catalina:      "fca9616931ae7e885cb02c10eeae0e64582d4db3c0f2ba6b8578498e9a2dd231"
    sha256 cellar: :any_skip_relocation, mojave:        "96040f379d0f9f4e2fe5838a5798565aff85dce06c93194bcf10dd7c20ec2cc3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
