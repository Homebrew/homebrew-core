class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/refs/tags/v0.15.1.0.tar.gz"
  sha256 "0187bb335205f6b5c9c78d3fc27deb59ce7122c7eb7429b88971d8cb25d7be51"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "636a0426df19f6ff5e1bf0ce1256bf57b69c9e8563653e984bce28d75a04c6c4"
    sha256 cellar: :any,                 arm64_sequoia: "cd766c7c8c5cb06debbe9c331916280058dfa6245a8a22ff3b055859dc982909"
    sha256 cellar: :any,                 arm64_sonoma:  "7a470983136a1c6ec36b477f9dfac734781afcf907a33d85d83d1faa17bb5501"
    sha256 cellar: :any,                 arm64_ventura: "44d4be8b570687514592eef731c60ad2f34e6e48d6ee57141ae90eaa28d89a10"
    sha256 cellar: :any,                 sonoma:        "adb984643626bd491580f169f3578f22639d4f1532a22a97c88f32a057996b33"
    sha256 cellar: :any,                 ventura:       "4bbdbc8b5a5cc050f6a6cb47297c3f9f77ab3f90da7d56758e750a3ddc499fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3be00f8a82099f4031c5068c33f6be734a36b2a21c30941805a9238f84e12849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442f39eb248892c063cc1dc89aa2ed7b1acb33e99d8ce76fc1493b8f63d9886e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    HASKELL
    expected = <<~HASKELL
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    HASKELL
    assert_equal expected, shell_output("#{bin}/stylish-haskell test.hs")
  end
end
