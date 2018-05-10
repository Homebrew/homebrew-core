class Taskell < Formula
  desc "Command-line kanban board/task manager written in Haskell"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.1.0.tar.gz"
  sha256 "77ad4aaeb1121445f2f6f7553d75e0c1fa47734ac3089c4595b8ba1d27b9b126"

  depends_on "haskell-stack" => :build

  def install
    system "stack", "build"
    system "stack", "install", "--local-bin-path=#{bin}"
  end

  test do
    system "#{bin}/taskell", "-v"
  end
end
