class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "5709f5a5fe4c6eae29994c90573ac364dabc4f060b99932c8abe120486865df7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c73de1e0329a3657645cfb7ed75b2e363814f9d020f248ff552dadd8127b97d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a06d9fbecddb14b9fb76ff8e798e8a7d38b19a44a441b6bf3e0cb8a5433b5d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44730c20406f49bc21d636bcc7e2dfb3b8e01ebb07c406f4af0905e0cac40597"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "679596defb801396ce0da0c5bf83e6b89de05eb60318f6d00e55c5318d93d82c"
    sha256 cellar: :any_skip_relocation, sonoma:         "402b4d1c7c93ba3e0111653b78457386833831082fa155923f0ce7332c57ac69"
    sha256 cellar: :any_skip_relocation, ventura:        "50997a2e71ebf9d8f7bcb1d4f690b470c0729e38a01dfe0f22052c17130fa3ac"
    sha256 cellar: :any_skip_relocation, monterey:       "1e485c50cb7d7576f6eeb6db450a73e944a11e03e351cc94d3d24782abed1fd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3e0422c603a98d13e6b0807b9cafdc9423e307b4f7b3b972cc06f37d1ba4645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f7f7403fc0e8eaacdcfd907e2bd9cd30d36487e2709e316b791fba61e8183f7"
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
