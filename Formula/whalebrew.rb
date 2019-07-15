class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
    :tag      => "0.2.3",
    :revision => "7b371f6e0fa414e61761359441268b61c8a741ff"
  head "https://github.com/whalebrew/whalebrew.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4788986bffaaad6defb524a5e2f8d7093f77fbd0004fa0f4cf52ebcb4134e240" => :mojave
    sha256 "0c0a716fc4755fe07bf3594ec29fa937b1b553f9cdd76ec929551a6be55f2e19" => :high_sierra
    sha256 "5cf2de32568a395555ea80737756f616866e6109f19f561d8b19562918293103" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    system "go", "build", "-o", bin/"whalebrew", "."
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
