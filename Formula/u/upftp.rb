class Upftp < Formula
  desc "Modern cross-platform multi-protocol file sharing server"
  homepage "https://github.com/zy84338719/upftp"
  url "https://github.com/zy84338719/upftp/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "358e10051eecf3a760b7dc9b079a3c813fdc6abae0437c4a7c2f25e7b11a04f0"
  license "MIT"
  head "https://github.com/zy84338719/upftp.git", branch: "main"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    # Build frontend
    cd "web" do
      system "npm", "ci"
      system "npm", "run", "build"
    end

    # Build backend
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.LastCommit=#{Utils.git_head}
      -X main.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/server"
  end

  def caveats
    <<~EOS
      To start upftp, run:
        upftp -auto

      Or for more options:
        upftp -h
    EOS
  end

  test do
    assert_match "upftp", shell_output("#{bin}/upftp -h", 1)
  end
end
