class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v2.0.0.tar.gz"
  sha256 "071ba2a39b62e7914a233af74e7935ddb7a875bc2a5f193cd43862da65b1c516"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f567dea995e69a581eaf1b78d288c8193dfdb4068e8114f80794e7eadf4e108a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a5c72d8022b7c7bc20511f07ff9f8dcd9637bffe596554ca7a9671dda8e713e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a6c8a7b7499e2b4d22c1fcb903545a7602c5762bc4b86f84fcd2c238f18c2ad"
    sha256 cellar: :any_skip_relocation, ventura:        "6adfa73341672560f138bfefd050ffaefb400151b293d68af8c146e9382f739b"
    sha256 cellar: :any_skip_relocation, monterey:       "6044828f80d3b03acad78089a4a0608512f6aa0a1316b181d76da12aa098da0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "777c1ba9464e94d016028f2892e9e50e95d4b41817fda1fecc67c8caab029bbf"
    sha256 cellar: :any_skip_relocation, catalina:       "59397ab86cef290c6ce4b9c3d3bda0f89997d3cf5017b83b46575a7407a4a316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93ce74ef95c2f4cb8ea2c3ece364712611680fd719884f1efbfdca4e0198784f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/triangle", "./cmd/triangle"
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
