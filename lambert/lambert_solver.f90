program lambert_solver
    use kind_module, only: wp                  ! Define working precision wp (from kind_module)
    use lambert_module, only: solve_lambert_izzo
    implicit none

    real(wp) :: r1(3), r2(3), mu, dt
    real(wp), allocatable :: v1(:,:), v2(:,:)
    logical :: status_ok
    integer :: ios
    integer, parameter :: in_id = 10, out_id = 09

    ! Display
    print *, "  Solving lambert's problem."

    ! Open files
    open(unit=out_id, file="lambert/lambert_output.dat", status="replace", action="write")
    open(unit=in_id, file='lambert/lambert_input.dat', status='old', action='read')

    do
      read(in_id, *, iostat=ios) r1(1), r1(2), r1(3), r2(1), r2(2), r2(3), dt, mu
      if (ios /= 0) exit  ! Exit loop on end-of-file or error

      call solve_lambert_izzo(r1, r2, dt, mu, .false., 0, v1, v2, status_ok)
      write(out_id, "(3F15.6)", advance="no") v1(1,1), v1(2,1), v1(3,1)
      call solve_lambert_izzo(r1, r2, dt, mu, .true., 0, v1, v2, status_ok)
      write(out_id, "(3F15.6)") v1(1,1), v1(2,1), v1(3,1)

      !write(out_id, "(A,3F15.6)") "V2 (km/s):", v2(1,1), v2(2,1), v2(3,1)
    end do

    ! Display
    print *, "  Finish solving."

    ! Close files
    close(in_id)
    close(out_id)
  
  end program lambert_solver
  