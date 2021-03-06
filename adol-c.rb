require 'formula'

class AdolC < Formula
  homepage "https://projects.coin-or.org/ADOL-C"
  url "http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.5.2.tgz"
  sha1 "6a17cb179dcbc59edc45c97b8928a2ebfa1e2c38"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "da92ef6e184a3caa0edfec5a8c60aaa2485566e1" => :yosemite
    sha1 "06f0ae04b6a3379585b1c1fce90f09715ae8d851" => :mavericks
    sha1 "0c3f381d7954e02183e5f23618abc156f5073fcc" => :mountain_lion
  end

  head 'https://projects.coin-or.org/svn/ADOL-C/trunk/', :using => :svn

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "colpack" => [:recommended, 'with-libc++']

  fails_with :llvm

  fails_with :gcc do
    build 5666
    cause "C++ compilation error."
  end

  def install
    ENV.cxx11

    # Configure may get automatically regenerated. So patch configure.ac.
    inreplace %w(configure configure.ac) do |s|
      s.gsub! "lib64", "lib"
    end

    args =  ["--prefix=#{prefix}", "--enable-sparse"]
    args << "--with-colpack=#{Formula["colpack"].opt_prefix}" if build.with? "colpack"
    args << "--with-openmp-flag=-fopenmp" if ENV.compiler != :clang
    args << "--enable-ulong" if MacOS.prefer_64_bit?

    ENV.append_to_cflags   "-I#{buildpath}/ADOL-C/include/adolc"
    system "./configure", *args
    system "make install"
    system "make test"

    # move config.h to include as some packages require this info
    (include/"adolc").install "ADOL-C/src/config.h"
  end
end
