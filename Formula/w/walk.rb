class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "606568e098a91c7b0e694534bf0d268d92cc9ac19bce9e4671775837176eb9f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "504e4846c09e6db3de651514150a0b2940d93d69f013a8c50b95844e2ee67c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "504e4846c09e6db3de651514150a0b2940d93d69f013a8c50b95844e2ee67c33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "504e4846c09e6db3de651514150a0b2940d93d69f013a8c50b95844e2ee67c33"
    sha256 cellar: :any_skip_relocation, ventura:        "e46b2b053dd1a65b7bbcb96b9735c17a4e916e19e9db1b3bd49c87a5225f2a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "e46b2b053dd1a65b7bbcb96b9735c17a4e916e19e9db1b3bd49c87a5225f2a1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e46b2b053dd1a65b7bbcb96b9735c17a4e916e19e9db1b3bd49c87a5225f2a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a428549fbba7dbe9cd59fa25cc9ceae79554c6a3b776b7e09e7348428118924"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"walk") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
