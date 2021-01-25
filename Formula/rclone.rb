class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.4.tar.gz"
  sha256 "acb53ccef1c1e638e53ca24933510d9be3666145372e1163470aa38414af8d48"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c189dd07e5c249f308296ecaa9a083840d8e8df878c6c71ccc55bd23f669b77e" => :big_sur
    sha256 "9954bbafd76d3a3f65a557bfb61251a69bc791a3b9e1461b7c37d8934891e59a" => :arm64_big_sur
    sha256 "0542cd81c381f5c1c417b9b77a182016bb6589f2f040b6fbc82d5b35ab386e2a" => :catalina
    sha256 "ff0011b501573d3e9127b52635bf07c77d01b9a464d52a63422039dcad365e4f" => :mojave
  end

  depends_on "go" => :build

  def install
    args = *std_go_args
    on_macos do
      args += ["-tags", "brew"]
    end
    system "go", "build",
      "-ldflags", "-s -X github.com/rclone/rclone/fs.Version=v#{version}",
      *args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
