class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.14.tar.gz"
  sha256 "592310fe87b59e28e290e3bc0ae7b7aa2fd85b0e53538b2f71f3b83c120f1d39"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03336d9de9dc202745816e823e5088dca49db28fba3ebe0021473e9ea8ae5a19" => :catalina
    sha256 "60b1aa35c746ac5f41cf385b37c66668229e1be139631d38e1a439691d97ba3e" => :mojave
    sha256 "3db9a9e2315f713eaaf0f53af304c3a70e4405c4e660f171ffc7adcbe7b74c8b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
