class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "70230e086968d7b97d6712f8956a2d8c03cabfd734ebeb4db3e655ca6a73711a"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e849d2da7824380c09713dbfea55855c600e51f7874a1588451f74512d09fc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e984f3d010b636a95a8f28ba1c6789498ac17a3362571ec3673a56ec6413cd88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc108dcfd4757e2a4f9bdc2516639115f6f412eb6e359af5e153392f63b6ea4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a0881d7f58716c2f319b3d49484395ac19fd5b1e0ef740daf86f9a41e3af9fd"
    sha256 cellar: :any_skip_relocation, ventura:        "422c40ab1b901f18fdc2c4157957b3f2e1b2d2e1b1c018ee9c3928d38e200d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "795a7f10c5195df3661ada6c0d1177778d20fbd25577b5369d8770a873a15b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52090090216b2ca1db93b8eb7b0be752eaa3067036038707ed9069aa519d5276"
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
