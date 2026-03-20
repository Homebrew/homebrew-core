class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "9988ae276f52d13e8a99fd088785cb6cf64bc129ee9c13eac78e024c7e985c83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a18ad81d7668b7fef83d9c1520ed8450bfe5c5f03b80cf4b514447dbee471169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3593b03825bfa008e7af0f6b745bc95b0812d5f4b62ced7fe1e23bb2f9bead3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be5132844a6621639f51b68bb995e25c0ed121842b99882e28571188a81e61c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a069775c4b2e8f6d1252a35f8cffb59e5b065f5ad47419d65f5413e6953a5c76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3f03fc704110e1a60469f58017a5b45f5895551cb0275c983aa0237d24b209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc046c1abb02add664442464bbe06c620cfae7d51f0bf7b455fe17c3551947c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
