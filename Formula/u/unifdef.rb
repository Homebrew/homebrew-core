class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "https://dotat.at/prog/unifdef/"
  url "https://dotat.at/prog/unifdef/unifdef-2.12.tar.gz"
  sha256 "fba564a24db7b97ebe9329713ac970627b902e5e9e8b14e19e024eb6e278d10b"
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause", # only for `unifdef.1`
  ]
  head "https://github.com/fanf2/unifdef.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "32f10f0ec152a2e92709ac763ae4538cc33d0504be7981302da2d9e183d55334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d582e3e4238886e561523bdc7f0a1066ac4316c06efd6efd710ba0e6f7ea5898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c67a592e10c3d607f6ea9676fe8bb6ac59472b2eec185261e9d382d186f65707"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "703fd0028a589e6862e6fb89564a0f1bbb17091dd5d9b35b7c338e172e8d554c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f6b3c3f19a6bcf92928abedb4b6b77249fd8b88caa25495c6dd2367f34d6ac0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dbc4bc39701aac4f2da738734f72bc002ad3e3e802343405b5c4acd1eb42928"
    sha256 cellar: :any_skip_relocation, sonoma:         "20af4f3b948e04fda28c60eb66b3f8b641073d2b4f84ecc54c0df4172961484f"
    sha256 cellar: :any_skip_relocation, ventura:        "dc78ddeb1a4e7a7501b778360e664f0ddb7a66945b5ee66141a8292f072fbce5"
    sha256 cellar: :any_skip_relocation, monterey:       "a4f1210ad5c6a8b1c4673aec0339343492ac84eadec4c16a4ebf259e982604af"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa7b0d6df5dfa2fbaa5886881def3b22b1bb55917f3734f7aede03816c257b28"
    sha256 cellar: :any_skip_relocation, catalina:       "ae908aa0c1845ce059576df3922808db790fb0ea91109f89aa930c8da7a68904"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ea9e4af82e2fb61fc1cc1ebeac02116bd1cf6a62d2d3e6fd3f4aabaac946487f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb229f3727c18db662a53be7406a73ed233acd172bb161e53af606baa4de016b"
  end

  keg_only :provided_by_macos

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    pipe_output(bin/"unifdef", "echo ''")
  end
end
