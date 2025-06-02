class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "3aa9b1af070c992031d3bb13751ef1f5dc5565e7e9a15ce078a541667b65f480"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7ccb539499a4ef441c67b37c0cac5f2b5e97ddf8d983c8fb912920e9b3f8682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9641ac9d5b2f581a9874c3d281856e229f8b2cbfb9db7fb2f6b3164e9a4b6f1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d85659b23f139f9590a5d7e39e9e5bb8c573063ce4d5cf1698418f7facb5de6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "97d4e07ef6df630853ae04d1dbfe5c9b016b4bce7416afa4ebf643ebbfc355e0"
    sha256 cellar: :any_skip_relocation, ventura:       "8ca2962c9d3567e6a07f319313402f495967ec3ac1135d4dc523a0ce6a88c192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2468087ae388452297938f9094dff29b52b767ec96fa0b3db8510d56fbe41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a0efa037d29f2d01c29299d0bf45d7c490aabb7e027220a0de00c812b9de50"
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
