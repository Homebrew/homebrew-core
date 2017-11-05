class RstudioServer < Formula
  desc "Integrated development environment (IDE) for R"
  homepage "https://www.rstudio.com"
  url "https://github.com/rstudio/rstudio/archive/v1.1.383.tar.gz"
  sha256 "6edc85f98366a94f0c9939dde8d25950c65580c9eed7ac245903e0aa1205c818"
  head "https://github.com/rstudio/rstudio.git"

  depends_on :java => "1.8"
  depends_on "r" => :recommended
  depends_on "cmake" => :build
  depends_on "ant" => :build
  depends_on "boost"
  depends_on "openssl"

  if build.head?
    resource "gin" do
      url "https://s3.amazonaws.com/rstudio-buildtools/gin-2.1.2.zip"
      sha256 "b98e704164f54be596779696a3fcd11be5785c9907a99ec535ff6e9525ad5f9a"
    end

    resource "gwt" do
      url "https://s3.amazonaws.com/rstudio-buildtools/gwt-2.8.1.zip"
      sha256 "0b7af89fdadb4ec51cdb400ace94637d6fe9ffa401b168e2c3d372392a00a0a7"
    end
  else
    resource "gin" do
      url "https://s3.amazonaws.com/rstudio-buildtools/gin-1.5.zip"
      sha256 "f561f4eb5d5fe1cff95c881e6aed53a86e9f0de8a52863295a8600375f96ab94"
    end

    resource "gwt" do
      url "https://s3.amazonaws.com/rstudio-buildtools/gwt-2.7.0.zip"
      sha256 "aa65061b73836190410720bea422eb8e787680d7bc0c2b244ae6c9a0d24747b3"
    end
  end

  resource "junit" do
    url "https://s3.amazonaws.com/rstudio-buildtools/junit-4.9b3.jar"
    sha256 "dc566c3f5da446defe36c534f7ee19cdfe7e565020038b2ef38f01bc9c070551"
  end

  resource "selenium" do
    url "https://s3.amazonaws.com/rstudio-buildtools/selenium-java-2.37.0.zip"
    sha256 "0eebba65d8edb01c1f46e462907c58f5d6e1cb0ddf63660a9985c8432bdffbb7"
  end

  resource "selenium-server" do
    url "https://s3.amazonaws.com/rstudio-buildtools/selenium-server-standalone-2.37.0.jar"
    sha256 "97bc8c699037fb6e99ba7af570fb60dbb1b7ce30cde2448287a44ef65b13023e"
  end

  resource "chromedriver-mac" do
    url "https://s3.amazonaws.com/rstudio-buildtools/chromedriver-mac"
    sha256 "5bf42fd9bcc45d45b54a0f59d5839feb454f39fd14170b8fab7f59bf59b1af64"
  end

  resource "chromedriver-linux" do
    url "https://s3.amazonaws.com/rstudio-buildtools/chromedriver-linux"
    sha256 "1ff3e9fc17e456571c440ab160f25ee451b2a4d36e61c8e297737cff7433f48c"
  end

  resource "dictionaries" do
    url "https://s3.amazonaws.com/rstudio-dictionaries/core-dictionaries.zip"
    sha256 "4341a9630efb9dcf7f215c324136407f3b3d6003e1c96f2e5e1f9f14d5787494"
  end

  resource "mathjax" do
    url "https://s3.amazonaws.com/rstudio-buildtools/mathjax-26.zip"
    sha256 "939a2d7f37e26287970be942df70f3e8f272bac2eb868ce1de18bb95d3c26c71"
  end

  resource "pandoc" do
    url "https://s3.amazonaws.com/rstudio-buildtools/pandoc/1.19.2.1/macos/pandoc-1.19.2.1.zip"
    sha256 "9d6e085d1f904b23bc64de251968b63422e7c691c61b0b6963c997c23af54447"
  end
  resource "pandoc-citeproc" do
    url "https://s3.amazonaws.com/rstudio-buildtools/pandoc/1.19.2.1/macos/pandoc-citeproc-0.10.4.zip"
    sha256 "11db1554ffd64c692a4f92e7bfa26dbe685300055ab463130e6fd4188f1958ae"
  end

  resource "libclang" do
    url "https://s3.amazonaws.com/rstudio-buildtools/libclang-3.5.zip"
    sha256 "ecb06fb65ddf0eb7c04be28edd11cc38717102afbe4dbfd6e237ea58d1da85ea"
  end

  resource "libclang-builtin-headers" do
    url "https://s3.amazonaws.com/rstudio-buildtools/libclang-builtin-headers.zip"
    sha256 "0b8f54c8d278dd5cd2fb3ec6f43e9ea1bfc9e8d595ff88127073d46550e88a74"
  end

  def install
    unless build.head?
      ENV["RSTUDIO_VERSION_MAJOR"] = version.to_s.split(".")[0]
      ENV["RSTUDIO_VERSION_MINOR"] = version.to_s.split(".")[1]
      ENV["RSTUDIO_VERSION_PATCH"] = version.to_s.split(".")[2]
    end

    gwt_lib = buildpath/"src/gwt/lib/"
    if build.head?
      (gwt_lib/"gin/2.1.2").install resource("gin")
      (gwt_lib/"gwt/2.8.1").install resource("gwt")
    else
      (gwt_lib/"gin/1.5").install resource("gin")
      (gwt_lib/"gwt/2.7.0").install resource("gwt")
    end
    gwt_lib.install resource("junit")
    (gwt_lib/"selenium/2.37.0").install resource("selenium")
    (gwt_lib/"selenium/2.37.0").install resource("selenium-server")
    (gwt_lib/"selenium/chromedriver/2.7").install resource("chromedriver-mac")

    common_dir = buildpath/"dependencies/common"

    (common_dir/"dictionaries").install resource("dictionaries")
    (common_dir/"mathjax-26").install resource("mathjax")

    resource("pandoc").stage do
      (common_dir/"pandoc/1.19.2.1/").install "pandoc"
    end

    resource("pandoc-citeproc").stage do
      (common_dir/"pandoc/1.19.2.1/").install "pandoc-citeproc"
    end

    resource("libclang").stage do
      (common_dir/"libclang/3.5/").install "mac/x86_64/libclang.dylib"
    end

    (common_dir/"libclang/builtin-headers").install resource("libclang-builtin-headers")

    mkdir "build" do
      args = ["-DRSTUDIO_TARGET=Server", "-DCMAKE_BUILD_TYPE=Release"]
      args << "-DRSTUDIO_USE_LIBCXX=Yes"
      args << "-DRSTUDIO_USE_SYSTEM_BOOST=Yes"
      args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
      args << "-DBOOST_INCLUDEDIR=#{Formula["boost"].opt_include}"
      args << "-DBOOST_LIBRARYDIR=#{Formula["boost"].opt_lib}"
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}/rstudio-server"
      args << "-DCMAKE_CXX_FLAGS=-I#{Formula["openssl"].opt_include} -D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0"

      linkerflags = "-DCMAKE_EXE_LINKER_FLAGS=-L#{Formula["openssl"].opt_lib} -L#{Formula["boost"].opt_lib}"

      args << linkerflags

      system "cmake", "..", *args
      system "make", "install"
    end

    bin.install_symlink prefix/"rstudio-server/bin/rserver"
    bin.install_symlink prefix/"rstudio-server/bin/rstudio-server"
    prefix.install_symlink prefix/"rstudio-server/extras"
  end

  def post_install
    # patch path to rserver
    Dir.glob(prefix/"extras/**/*") do |f|
      if File.file?(f) && !File.readlines(f).grep(/#{prefix/"rstudio-server/bin/rserver"}/).empty?
        inreplace f, /#{prefix/"rstudio-server/bin/rserver"}/, opt_bin/"rserver"
      end
    end
  end

  def caveats
    daemon = <<-EOS

            If it is an upgrade or the plist file exists, unload the plist first
            sudo launchctl unload -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist

            sudo cp #{opt_prefix}/extras/launchd/com.rstudio.launchd.rserver.plist /Library/LaunchDaemons/
            sudo launchctl load -w /Library/LaunchDaemons/com.rstudio.launchd.rserver.plist
    EOS

    <<-EOS.unindent
      - To test run RStudio Server,
          sudo #{opt_bin}/rserver --server-daemonize=0

      - To complete the installation of RStudio Server
          1. register RStudio daemon#{daemon}
          2. install the PAM configuration
              sudo cp #{opt_prefix}/extras/pam/rstudio /etc/pam.d/

          3. sudo rstudio-server start

      - In default, only users with id >1000 are allowed to login. To relax
        requirement, add the following option to the configuration file located
        in `/etc/rstudio/rserver.conf`

          auth-minimum-user-id=500
    EOS
  end

  test do
    system "#{bin}/rstudio-server", "version"
  end
end
