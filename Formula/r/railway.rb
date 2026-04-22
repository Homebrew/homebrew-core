class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.40.2.tar.gz"
  sha256 "3c042102ac6b81894ee8410913313ecd1ef2e9683670c7c1d3f8b55f32442bb1"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5101dd22c1cf1704640d5489e2197c2cd2b5ad0e02d0093a37b41feccfd16f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "702f0fdbb505bb692cabbfb21d7bbb6be460e486c303cb974529db6b4f9825f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66fd4eb2282e021b3f407e1ef92534f2c77dfe9a55dcd31d08e8aa1169de92d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f88fbfe220fa938906b044bb22f58bd16672fa88797c1d02b0991ccda40f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50c480251f4c024f244d7f80c4d3e107f31ecfc5626d6a7b08be60e77effc015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "912a134e41413d267728de62a378b28e4607194387d59ca4c080d2e8580119ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
