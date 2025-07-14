class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "e04cdcd74a1b41a3f46b67ec99f941fd149a79a3d2b8eb8fb095b3883d564f05"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae7ad1b7852267faf16fe9e73d69a04c54afc7e3663329381403a5880f470c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90e80fa9f25f9496c83e67a292b761ce75223d81d3e7be4522867925fc5e9e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a53534861bdae31dcff24b2baecbfc1bce6dc9f085d6e0fda499c20f5ed177bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "afab63b27f0c80eef043088ee6ad22e5dd8aba79f4b28b2a25e74ee634a81f40"
    sha256 cellar: :any_skip_relocation, ventura:       "3918e238835168b1fd4f4a6c30cd129c1c0bc0ecbc7aa1d206b425e00e7e144f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc7cd756939f87a85b84b5c3aec00d289fc071aee405b4d9292b2f17b8a8a094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0576f81cecdd1fa7a3bc0478395d3030a1d9a1636b24356b4510ff796649916"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end
