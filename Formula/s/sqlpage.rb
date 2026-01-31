class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "6bb1b40a4bef392c7b6c7d2f480be4ed78cd3474c38d55f61875c38605548ae1"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81794c5a53d80246d8200391e85519dad26903b92a9bd102b729a4e753f55cbf"
    sha256 cellar: :any,                 arm64_sequoia: "7bd6bfd080e274f0b316afe403a8b69ef0d318d1d4c0c1c1adc834805f50f04b"
    sha256 cellar: :any,                 arm64_sonoma:  "963c6f701e8d157970ff7f1b1b1cfee4400a81fb9c44668dfc210429b102a242"
    sha256 cellar: :any,                 sonoma:        "20979861bb6ed73967141d3f6b102e6cf73cab80ab7cd7f03ada8f76e084049b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6587be5ea69b037caa94745a280e7215245999b179d64724e7e878925dcd1bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13ff127930824305e30105e8c1c3d892b91d7333a5561787b096cb3bb0d83d13"
  end

  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    ENV["PORT"] = port.to_s
    pid = spawn bin/"sqlpage"

    assert_match "It works", shell_output("curl --retry-connrefused --retry 4 --silent http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
