class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "77dde6ec60f34d008861a894dbcdcd50db3646890d1cf3fbdafdf36912803ea0"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d179885fc95ba49073d90e82a3834b9c168fb6adcb8e2165a4fcc4a6732e5b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36da0810157c8a89cbd3e8e0905ca9dbc2dff4f254c05ca3b4a57a4c630e18aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a5ba24214f0bc6a698a82c55df1a09d54c133fcdc97e22d43f481b21a60169a"
    sha256 cellar: :any_skip_relocation, sonoma:        "55a9213995b23782bcf5dbdc79b490c05d6361c995822e68df29d0d643974dfa"
    sha256 cellar: :any_skip_relocation, ventura:       "64073b29ba0313173c03e4acf06d7e24ac3b8a60b2faecd3eb972a7e7dcc1240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c4c85a46c9548d6fbb914561608032076b97df3d5fde775d3d19100b9fb957f"
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
