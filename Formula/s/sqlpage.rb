class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "c54dd46d2fd54572c2ad4a0060ae0cd74409944337b645f4914e4b36667aef58"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b343070587f6f50b4d297de14f371a3dcfa10e41f9860f1dc0397c4d6e6393bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62bfce49b400a16d950b2157ec7c9577d81f59f685e0bdac13bef08b114edd59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a72c35ec9e20c5b2ba423036deef14de2f6470dcf9870404a2ca75d16ce111"
    sha256 cellar: :any_skip_relocation, sonoma:         "58acc23b513bf504bd90f5dc14845a3d7a4dfd772234882288fd3c212557ab7a"
    sha256 cellar: :any_skip_relocation, ventura:        "fda344d60ef7479c3a762fdd76ade9d42c1dc4ec2c2b0141419c55a92869041b"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a8718879f46b284fca8cd88be29e09bd57f127ead33ef824b083a85642e9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a4f7710d2a808a87dc019b98d4d286d2c00a35f369bfab38d6856dbe88bdac"
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
