class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "d891aabae2b482128c1536e92b8dc7ba17876060db1b17a9b7f084013662e09b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b64ec512391d4f54510c5884c6473a7889cd9cafaca9396ddb6517f88c8522de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4fb932e27d86371590a58154e697ec6e7798f8952a3e6d7d7e22985487c27e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076fa390e17020e7371e8dd608bd41d6dd4da8015f042f6c62b24b2e13566f4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "25e82445a0a1dee957bc3376b6b5c483dde893b6c2499577f65062b79a13d374"
    sha256 cellar: :any_skip_relocation, ventura:        "8a6d81bd1f694a5deed602ec038114ac216788c9fe13d0aecdcbfd8162594934"
    sha256 cellar: :any_skip_relocation, monterey:       "c1dfcd72fb6181ef5b09776a8ecc7355bfed902e80d2654989da1645ee5584f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf94d1afafd40cfc94932ae9b3cec5092954684a80788f67d343ce55082c940c"
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
