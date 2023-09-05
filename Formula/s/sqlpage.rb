class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "42d4a39bd1ebc856971fbee6affbb8da9e37a4e75cd721a630d0800edb2ede19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f557b79c595a8202c806af9a9e7010dde8d1d19f5f1671ccf5ccfaed7f432104"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7dd2c5d61f31c81711d755d450c7dd093d3c599352a42c358bd22bc1bc01632"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7ea270273695d4c43008ca743eb6988edad6d2d0d22d20561f2bba2fdf0cafe"
    sha256 cellar: :any_skip_relocation, ventura:        "c781e5ae0c8a2cfa0670de04f779aaddf77fd6ad6c57d1f127fa51cf1f716b2d"
    sha256 cellar: :any_skip_relocation, monterey:       "d64d7c37903e7cf374084eb0869e77de6a142bbbaa6e904576954de2a0f39286"
    sha256 cellar: :any_skip_relocation, big_sur:        "72fbb1f63a0f5345dbeba59c4b08b6102cfccca485ca49076609d2ee0f7d9bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533a9eab3fa896b2672a7d45f35b3ce6f272f839a6010a543b7625cbddf455dd"
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
