class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "66115d80ac54a8024f191e81f72f9b7f6dda9db1de907f3570c1939532ca9e72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af303994c95961de53c33c377c5c90030368fc125b420fc0a837155fcef790c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c718d8bc4bb7a6fdc6eee45966bd6be4f2cfae6d7ea18c165004bd9cb60d77d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c769dfa1d56fcbfc066c2fcd5439f99a9d25093e92e99eb0ff7a36bd024bcac2"
    sha256 cellar: :any_skip_relocation, ventura:        "6b891398d9cd417c7443082e4217c421a1d4bc4e00942ea732747c26ad3159ef"
    sha256 cellar: :any_skip_relocation, monterey:       "6e7548076cc9d809807de1594c739fdc17c2bf6c7668fae28a727d064477c429"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d81521837ef5ae1a65a478ee4e3c80cefd61f757a0918628af201a05e386636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d29dde460a779bee1e16b56dd9d8d714589d67fa9a52e4acaa33522983d15f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
