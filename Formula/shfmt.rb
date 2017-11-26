class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.1.0.tar.gz"
  sha256 "2f39dc1d34e87190b659ed677a83e32f9ef769cd8adb34f8c4ccf0a9091b109f"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06c2f69eca5c5e850604a901bb04c9949f40c0b42e48202824ef71ee66475dff" => :high_sierra
    sha256 "a050e40ce0752fe45446c34729c2d81b8cf248fe9629c4d072b188470d9b0003" => :sierra
    sha256 "e5df9645eb97fbe6e1792e0a6018c9ca0b09ac4bcb9875ebb0ecbcd0799f6cdb" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-o", "#{bin}/shfmt", "mvdan.cc/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
