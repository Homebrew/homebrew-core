class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.17.0.tar.gz"
  sha256 "43652cfc5fec2a115d18a055b4e67e32a9c48acf5ea851a96be6d80bbd87a039"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8afefc5adde667769e960d023acbc52c7882f3362611e9a22702a51b8b0521a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b728fa7838d72872da20fea904f43ee69519a01db50ffc956a06ff1ba8c643c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "367759694e143003fd051d7d313faa31dae122fa1bb91908cba63617401f2a75"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8fd6c0e0ec2de1be18979b8b635c4b310837d2af29d606767deebaf87886b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4f084cf45b460420f50863889f544f3478fe73eb5fc60579335243d5248aa81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bc18d1ddd9279fcd030966065e48be909dc3e6bacf94cf9eb2bf483af507e8a"
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
