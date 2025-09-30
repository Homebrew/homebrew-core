class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "262ba8afda8b6849fe775cd7142566873200f811ba40e1f922781fe110f5fcec"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c60604adc9f6261e469494d43d0f02ed264d524796cea1e807ff5306af06e3a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f4cec015dfcf9e78ee094523568169cb0521c33c4b89ac0dea3abd443a67f8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a825c8c4225ade088b7e994c571f32f90912d9f51fae5c772855fd986437a38"
    sha256 cellar: :any_skip_relocation, sonoma:        "e70a806eda009308a2836678e667cc2878162146efaec43eec0723b33a76868c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aacf9e8b62a62e18621e7b39c2755049d5adf7ef07b06aef60f5ee5d69703646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee249c642255fe6d3b9343902d2b4c08c2a66eba6330e591ce0f85be161773f"
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
