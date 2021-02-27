class Threemux < Formula
  desc "Terminal multiplexer inspired by i3"
  homepage "https://github.com/aaronjanse/3mux"
  url "https://github.com/aaronjanse/3mux/archive/v1.1.0.tar.gz"
  sha256 "0f4dae181914c73eaa91bdb21ee0875f21b5da64c7c9d478f6d52a2d0aa2c0ea"
  license "MIT"
  head "https://github.com/aaronjanse/3mux.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"3mux"
  end

  test do
    require "open3"

    Open3.popen2e(bin/"3mux") do |stdin, _, _|
      stdin.write "brew\n"
      stdin.write "3mux detach\n"
    end

    assert_match "Sessions:", pipe_output("#{bin}/3mux ls")
  end
end
