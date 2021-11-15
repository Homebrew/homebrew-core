class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.16.3.tar.gz"
  sha256 "26636a2e2cc066184f12651ac6949f978fc041990dba73934960a4c9c1ea383d"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4c6d9e6ca584976f41e4e0496b84730ada560fcc6766d8fde0afafdc1b6b0f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4c6d9e6ca584976f41e4e0496b84730ada560fcc6766d8fde0afafdc1b6b0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "67ef975d666abc37d4838559895e7a28f95ba05a4d3a41988b381a056d7c438f"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ef975d666abc37d4838559895e7a28f95ba05a4d3a41988b381a056d7c438f"
    sha256 cellar: :any_skip_relocation, catalina:       "67ef975d666abc37d4838559895e7a28f95ba05a4d3a41988b381a056d7c438f"
    sha256 cellar: :any_skip_relocation, mojave:         "67ef975d666abc37d4838559895e7a28f95ba05a4d3a41988b381a056d7c438f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c189fd21afa356d7a11b55fc4784ec245e221cd410f9c844a9a34bf7889282da"
  end

  depends_on "python@3.10"

  def install
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack list zlib")

    # Set up configuration file and build paths
    %w[opt modules lmod stage test source misc cfg-store].each { |dir| (testpath/dir).mkpath }
    (testpath/"cfg-store/config.yaml").write <<~EOS
      config:
        install_tree: #{testpath}/opt
        module_roots:
          tcl: #{testpath}/modules
          lmod: #{testpath}/lmod
        build_stage:
          - #{testpath}/stage
        test_stage: #{testpath}/test
        source_cache: #{testpath}/source
        misc_cache: #{testpath}/misc
    EOS

    # spack install using the config file
    system bin/"spack", "-C", testpath/"cfg-store", "install", "--no-cache", "zlib"

    # Get the path to one of the compiled library files
    zlib_prefix = shell_output("#{bin}/spack -ddd -C #{testpath}/cfg-store find --format={prefix} zlib").strip
    zlib_dylib_file = Pathname.new "#{zlib_prefix}/lib/libz.a"
    assert_predicate zlib_dylib_file, :exist?
  end
end
