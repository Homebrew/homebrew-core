class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.2.tar.gz"
  sha256 "351f3face9f711ba2271e085af30e389d5be6dbaf4e993d14bb86da05b706400"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a715cf6f2f9a6afeb02f0d24d50ad097cd60a4e2b39408bcb8df28e70c670eb" => :catalina
    sha256 "6836f16576492e009938a9d48d278ef8919f65dc9b78590981bd1b1761d5642c" => :mojave
    sha256 "899b1600cfb4842016332439693d65ae844eb19ce0a68c580204ae07dda091bf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
