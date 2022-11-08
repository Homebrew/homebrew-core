class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.79.36.tar.gz"
  sha256 "898d1906642c067df9125f40cced738e93a6606bc07bf2245fe81923b45ade2d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80150db9e1901591601dfff08632bb4053bb2a3203c2f4aebdb1b04d12f8a93b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3bf7a226187294080d29c9f4c6a49d98959bbf7eb7a8d31cc11b0aa999cb7b5"
    sha256 cellar: :any_skip_relocation, monterey:       "41f0e8f4ce99caf5db4431c92259560ebcf637f13fb1d02684772787d870df32"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fbd47eb2b2ff8acac577b28c82c80426150c4a8a9b99ef5bb13cb9bf5835b47"
    sha256 cellar: :any_skip_relocation, catalina:       "7847d78010c72519f74fc2d67bb70d859006e4d95bbd4e36603765a20cbb28e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf9a400b373d991cbac3a66681d489bdfb2d3188c4a76d60016ba1a6f7a632b0"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
