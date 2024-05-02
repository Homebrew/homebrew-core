class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "6102e9ed298cf15929f5e7a37853daf4f6725bf199fd09407c34c566b456fdaf"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d64f84e58f2d251a5017f531ec937f2c9ceec8db663d3d70651d8b9f607d09ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c802cd99c477494539d38bd6bfed2a6ec075106fe8b6bb6185a82fa6928786"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86b6a3175964bc2b2d0182aa988b23d8f4a02ec01741ebc82bc091dd45737185"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5aed5b83d1bec8cc350f2d78a4e1f7475b4035fa92c206f88fd558d8c5e31b5"
    sha256 cellar: :any_skip_relocation, ventura:        "cdbec6639256c5109878cadd02e7982a34ac32abaa3b74a007ef88cc561f0ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "90c19ca5b77c52718bcdbae49f64c9f3246e334187687ecad87bee98ba481f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e70d1fe10959fef87018700316b4b84006fdd82abab6aa673079190580cb71d"
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
