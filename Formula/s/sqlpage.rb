class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "835a66d8fe89cbacadf7cb5f103fa5a98b7233cbf412fc9f0a2511d42104cb63"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4cc68b33dea9f9fe979a697917423e994a87ae1b5e74bef0ccb106ab16b3f94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "716966b1e60437712ad107d2fa1f38ab899a2def87e1b4b01bda83e0ca23d36f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f8f8b23695f4694dabb6f8cbc7c329fcdc458f63b809aafaba2afa6ecc4d55e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc2f27fe4f64bc7ec0a813e28d1d8d771357da561d746e0a307ac38267c8573f"
    sha256 cellar: :any_skip_relocation, ventura:        "eb954d3e9de0c7cd0c4fabfc376face73501a3ade6197fd682cd35e5e188f08d"
    sha256 cellar: :any_skip_relocation, monterey:       "18d6042ad798425e191541811df3208dbcc8bbe476321affe80d2caf41ae1aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6009d65b0200381f68695b4901fb02c1278301dd53d5fc01c34619ca84fdc304"
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
