class Topfew < Formula
  desc "Finds the field values which appear most often in a stream of records"
  homepage "https://github.com/timbray/topfew"
  url "https://github.com/timbray/topfew/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "89b9abe7304eb6bb50cc5b3152783e50600439955f73b6175c6db8aec75c0ac9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "565223383079283a6c12ede0f085804a272ce65f14d8ae5882667b517db5434f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bed91d915da3735f3b96723b744cbed823de57da2f096a5c337a6b170ddd5f19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d7f6c39d1e8eaed9de48d13494541f44f5aa09b74eb8a6436f8eb662026cccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d7f6c39d1e8eaed9de48d13494541f44f5aa09b74eb8a6436f8eb662026cccc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d7f6c39d1e8eaed9de48d13494541f44f5aa09b74eb8a6436f8eb662026cccc"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fa90b99c1b653a0c80c0f0468930f89ca1c3e50ab5927ddb38ff2f015f4e7b3"
    sha256 cellar: :any_skip_relocation, ventura:        "6fa90b99c1b653a0c80c0f0468930f89ca1c3e50ab5927ddb38ff2f015f4e7b3"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa90b99c1b653a0c80c0f0468930f89ca1c3e50ab5927ddb38ff2f015f4e7b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "342f33c16251a92b7b5ebf03802f9c005deff56d61c1a00cdcdc7c4b8289c5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dec313f97c765887b956f178a9794d411e67040886de5583bf3f7be97a263aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "1 bar", pipe_output("#{bin}/topfew -f 2", "foo bar\n")
  end
end
