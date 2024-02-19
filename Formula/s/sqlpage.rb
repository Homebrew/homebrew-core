class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "df738b70d00ff93afdc68d59de7ef30e6bac41e6ba3685f9574480b72ffda8dc"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bd74380774fc8475b4adb36e527fd2648647e59ccc99d58cb35ae01f197c38f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07883ba3303393b594558e80ca2bd7ec2745d8b18fc6d7f63dcfaf1af3375e5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6ffe3e3fc3a4ae32b06e51860c72368f197348f50dd9d7dc146983a5286a40"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5092d36c4095d6a7e7cae271b0853cb863bdd754377857b554fc91e65d36572"
    sha256 cellar: :any_skip_relocation, ventura:        "f6f9a8c8c84a471b809f19f59b2527f7b290c608527362c7cec92c3f7b35d6da"
    sha256 cellar: :any_skip_relocation, monterey:       "7bfa8dc911a7381dcb9dd5c93713ebcfb3b4d93d0f31b67aed98f27d4edfa1ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa977065c6cc227bf20cd6eb0e55a1dbaa100524cdcccaee947f413f6575c773"
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
